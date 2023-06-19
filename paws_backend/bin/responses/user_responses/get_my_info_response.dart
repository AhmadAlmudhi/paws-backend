import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import '../../response_messages/bad_request.dart';
import '../../response_messages/success.dart';
import '../../services/supabase/supabase_env.dart';

getMyInfoHandler(Request req) async {
  try {
    final myAuthId = JWT.decode(req.headers["authorization"]!).payload["sub"];

    final supabase = SupabaseEnv().supabase;

    final selectFromUsers = supabase.from("users").select();

    final List user = (await selectFromUsers.eq("auth_id", myAuthId));

    return Success().responseMessage(
      message: 'My info has been retrieved',
      data: user[0],
    );
  } catch (error) {
    print(error);

    return BadRequest().responseMessage(message: "something went wrong");
  }
}
