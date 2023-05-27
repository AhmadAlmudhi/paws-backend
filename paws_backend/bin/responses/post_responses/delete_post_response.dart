import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import '../../response_messages/bad_request.dart';
import '../../response_messages/not_found.dart';
import '../../response_messages/success.dart';
import '../../services/supabase/supabase_env.dart';

Future<Response> deletePostHandler(Request req, String postId) async {
  try {
    final supabase = SupabaseEnv().supabase;

    final jwt = JWT.decode(req.headers["authorization"]!);
    final authId = jwt.payload["sub"];
    final fromPosts = supabase.from("posts");

    final usersUserId = ((await supabase
        .from("users")
        .select("user_id")
        .eq("auth_id", authId))[0]["user_id"]);

    final List postUserId =
        (await fromPosts.select("user_id").eq("post_id", postId));

    if (postUserId.isEmpty) {
      return NotFound().responseMessage(
        message: "Post not found!",
      );
    }

    if (usersUserId == postUserId[0]["user_id"]) {
      final deletedPost =
          await fromPosts.delete().eq("post_id", postId).select();

      final deletedAnimal = await supabase
          .from("animals")
          .delete()
          .eq("post_id", postId)
          .select();

      return Success().responseMessage(
        message: "Post got deleted!",
        data: {
          "deleted post data": [deletedPost[0]],
          "deleted animal data": [deletedAnimal[0]],
        },
      );
    } else {
      return BadRequest().responseMessage(
        message: "something went wrong!",
      );
    }
  } catch (error) {
    return BadRequest().responseMessage(
      message: "sorry error ! $error ",
    );
  }
}
