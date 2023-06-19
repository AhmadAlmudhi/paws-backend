import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import '../../response_messages/bad_request.dart';
import '../../response_messages/success.dart';
import '../../services/supabase/supabase_env.dart';

getUserHandler(Request req, String id) async {
  try {
    final supabase = SupabaseEnv().supabase;

    final selectFromUsers = supabase.from("users").select();

    final tokenUserAuthId =
        JWT.decode(req.headers["authorization"]!).payload["sub"];

    final List tokenUser =
        (await selectFromUsers.eq("auth_id", tokenUserAuthId));

    final bool showEdit = tokenUser[0]["user_id"] == int.parse(id);

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
      "show_edit": showEdit,
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
