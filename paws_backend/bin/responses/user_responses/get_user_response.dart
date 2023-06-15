import 'package:shelf/shelf.dart';
import '../../response_messages/bad_request.dart';
import '../../response_messages/success.dart';
import '../../services/supabase/supabase_env.dart';

getUserHandler(Request _, String id) async {
  try {
    final supabase = SupabaseEnv().supabase;

    final user =
        (await supabase.from("users").select().eq("user_id", int.parse(id)))[0];

    final details = (await supabase
        .from("details")
        .select()
        .eq("user_id", int.parse(id)))[0];

    final contact = (await supabase
        .from("contacts")
        .select()
        .eq("user_id", int.parse(id)))[0];

    Map userMap = {
      "info": user,
      "details": details,
      "contact": contact,
    };

    return Success().responseMessage(
      message: 'User data has been retrieved',
      data: userMap,
    );
  } catch (error) {
    print(error);

    return BadRequest().responseMessage(message: "something went wrong");
  }
}
