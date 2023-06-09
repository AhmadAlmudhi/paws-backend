import 'package:shelf/shelf.dart';
import '../../response_messages/not_found.dart';
import '../../response_messages/success.dart';
import '../../services/supabase/supabase_env.dart';

Future<Response> readAllPostsHandler(Request _) async {
  try {
    final List<Map> result = [];

    final supabase = SupabaseEnv().supabase;

    final posts = await supabase.from("posts").select();

    for (var element in posts) {
      final Map animalInfo = (await supabase
          .from("animals")
          .select("type, breed, age, color, name")
          .eq("post_id", element["post_id"]))[0];

      final Map postInfo = element;

      Map post = {};
      post.addAll(postInfo);
      post.addAll(animalInfo);

      result.add(post);
    }

    return Success().responseMessage(
      message: "success",
      data: {"posts": result},
    );
  } catch (error) {
    print(error);

    return NotFound().responseMessage(message: "posts not found");
  }
}
