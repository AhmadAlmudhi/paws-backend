import 'package:shelf/shelf.dart';
import '../../../response_messages/bad_request.dart';
import '../../../response_messages/not_found.dart';
import '../../../response_messages/success.dart';
import '../../../services/supabase/supabase_env.dart';

Future<Response> getFavoritesNumberHandler(Request _, String postId) async {
  try {
    final supabase = SupabaseEnv().supabase;
    final fromPosts = supabase.from("posts");

    List favoritesNumberList = (await fromPosts
        .select("favorites_number")
        .eq("post_id", int.parse(postId)));

    if (favoritesNumberList.isEmpty) {
      return NotFound().responseMessage(
        message: "Post not found!",
      );
    }

    int favoritesNumber = favoritesNumberList[0]["favorites_number"];

    return Success().responseMessage(
      message: "this post has been favourited $favoritesNumber times!",
      data: {"favorites_number": favoritesNumber},
    );
  } catch (e) {
    return BadRequest().responseMessage(message: "Something went wrong!");
  }
}
