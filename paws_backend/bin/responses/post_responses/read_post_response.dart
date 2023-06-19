import 'package:shelf/shelf.dart';
import '../../response_messages/not_found.dart';
import '../../response_messages/success.dart';
import '../../services/supabase/supabase_env.dart';

Future<Response> readPostHandler(Request _, String postId) async {
  try {
    final supabase = SupabaseEnv().supabase;

    final postValues =
        (await supabase.from("posts").select().eq("post_id", postId))[0];

    final Map userInfo = (await supabase
        .from("users")
        .select("name, username, image")
        .eq("user_id", postValues["user_id"]))[0];

    final Map animalInfo =
        (await supabase.from("animals").select().eq("post_id", postId))[0];

    return Success().responseMessage(
      message: "success",
      data: {
        "user_info": [userInfo],
        "post_info": [postValues],
        "animal_info": [animalInfo],
      },
    );
  } catch (error) {
    return NotFound().responseMessage(message: "post not found");
  }
}
