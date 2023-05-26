import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import '../../../response_messages/bad_request.dart';
import '../../../response_messages/success.dart';
import '../../../services/supabase/supabase_env.dart';

Future<Response> toggleFavoriteHandler(Request req, String postId) async {
  try {
    final jwt = JWT.decode(req.headers["authorization"]!);
    final authId = jwt.payload["sub"];

    final supabase = SupabaseEnv().supabase;
    final fromUsers = supabase.from("users");
    final fromPosts = supabase.from("posts");

    final List userFavorites = ((await fromUsers
        .select("favorites")
        .eq("auth_id", authId))[0]["favorites"]);

    int favoritesNumber = (await fromPosts
        .select("favorites_number")
        .eq("post_id", int.parse(postId)))[0]["favorites_number"];

    String msg = "post has been removed from favorites!";

    if (userFavorites.contains(int.parse(postId))) {
      userFavorites.remove(int.parse(postId));
      --favoritesNumber;
    } else {
      userFavorites.add(int.parse(postId));
      ++favoritesNumber;
      msg = "post has been added to favorites!";
    }

    await fromUsers.update({"favorites": userFavorites}).eq(
      "auth_id",
      authId,
    );

    await fromPosts.update({"favorites_number": favoritesNumber}).eq(
      "post_id",
      int.parse(postId),
    );

    return Success().responseMessage(
      message: msg,
      data: {"favorites": userFavorites},
    );
  } catch (e) {
    return BadRequest().responseMessage(message: "Something went wrong!");
  }
}
