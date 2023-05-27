import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

import '../../response_messages/bad_request.dart';
import '../../response_messages/success.dart';
import '../../services/supabase/supabase_env.dart';

readProfileHandler(Request req) async {
  try {
    final header = req.headers;
    final supabase = SupabaseEnv().supabase;
    final selectUser = supabase.from("users");
    final jwt = JWT.decode(header['authorization']!);
    final userAuth = jwt.payload["sub"];

    final id = await selectUser.select("user_id").eq("auth_id", userAuth);

    final user =
        (await supabase.from("users").select().eq("auth_id", userAuth))[0];

    final details = (await supabase
        .from("details")
        .select()
        .eq("user_id", id[0]["user_id"]))[0];

    final contact = (await supabase
        .from("contacts")
        .select()
        .eq("user_id", id[0]["user_id"]))[0];

    Map userMap = {
      "info": user,
      "details": details,
      "contact": contact,
    };

    return Success()
        .responseMessage(message: 'here is your profile', data: userMap);
  } catch (error) {
    print(error);

    return BadRequest().responseMessage(message: "something went wrong");
  }
}
