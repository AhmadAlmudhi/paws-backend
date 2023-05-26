import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import '../../response_messages/bad_request.dart';
import '../../response_messages/success.dart';
import '../../services/supabase/supabase_env.dart';

Future<Response> deletePostHandler(Request req, String postId) async {
  try {
    final supabase = SupabaseEnv().supabase;

    final jwt = JWT.decode(req.headers["authorization"]!);
    final authId = jwt.payload["sub"];

    final userId = ((await supabase
        .from("users")
        .select("user_id")
        .eq("auth_id", authId))[0]["user_id"]);

    final deletedPost = await supabase
        .from("posts")
        .delete()
        .eq("post_id", postId)
        .eq("user_id", userId)
        .select();

    final deletedAnimal =
        await supabase.from("animals").delete().eq("post_id", postId).select();

    return Success().responseMessage(
      message: "Post created!",
      data: {
        "deleted post data": [deletedPost[0]],
        "deleted animal data": [deletedAnimal[0]],
      },
    );
  } catch (error) {
    return BadRequest().responseMessage(
      message: "sorry error ! $error ",
    );
  }
}
