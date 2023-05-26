import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import '../../../response_messages/bad_request.dart';
import '../../../response_messages/success.dart';
import '../../../services/supabase/supabase_env.dart';

Future<Response> addToFavoritesHandler(Request req, String postId) async {
  try {
    final jwt = JWT.decode(req.headers["authorization"]!);
    final authId = jwt.payload["sub"];

    final supabase = SupabaseEnv().supabase;
    final fromUsers = supabase.from("users");
    final fromPosts = supabase.from("posts");

    final List userFavorites = json.decode((await fromUsers
        .select("favorites")
        .eq("auth_id", authId))[0]["favorites"]);

    userFavorites.add(postId);

    await fromUsers.update({"favorites": json.encode(userFavorites)}).eq(
      "auth_id",
      authId,
    );

    int favoritesNumber = (await fromPosts
        .select("favorites_number")
        .eq("post_id", int.parse(postId)))[0]["favorites_number"];

    ++favoritesNumber;

    await fromPosts.update({"favorites_number": favoritesNumber}).eq(
      "post_id",
      int.parse(postId),
    );

    return Success().responseMessage(
      message: "post has been added to favorites!",
      data: {"favorites": userFavorites},
    );
  } catch (e) {
    print(e);

    return BadRequest().responseMessage(message: "Something went wrong!");
  }
}
