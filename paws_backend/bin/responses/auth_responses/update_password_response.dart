import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';
import '../../response_messages/bad_request.dart';
import '../../response_messages/success.dart';
import '../../services/supabase/supabase_env.dart';

updatePasswordHandler(Request req) async {
  try {
    final body = json.decode(await req.readAsString());
    final auth = SupabaseEnv().supabase.auth;

    if (body["email"] == null ||
        body["password"] == null ||
        body["code"] == null) {
      return Response.badRequest(body: "please enter the missing info");
    }

    final user = await auth.verifyOTP(
      token: body["code"],
      type: OtpType.recovery,
      email: body["email"],
    );

    if (user.session?.accessToken == null) {
      return Response.forbidden("sorry can't update password !");
    }

    await auth.updateUser(
      UserAttributes(email: body["email"], password: body["password"]),
    );

    return Success().responseMessage(
      message: "password is updated",
    );
  } on AuthException {
    return BadRequest().responseMessage(
      message: "sorry error ! $AuthException ",
    );
  } catch (error) {
    return BadRequest().responseMessage(
      message: "sorry error ! $error ",
    );
  }
}
