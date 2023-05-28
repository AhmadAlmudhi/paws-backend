import 'dart:convert';
import 'package:shelf/shelf.dart';

import '../../response_messages/bad_request.dart';
import '../../response_messages/not_found.dart';
import '../../response_messages/success.dart';
import '../../services/supabase/supabase_env.dart';

//check

forgotPasswordHandler(Request req) async {
  try {
    final body = json.decode(await req.readAsString());
    final supabase = SupabaseEnv().supabase;

    if (body['email'] == null) {
      return BadRequest().responseMessage(
        message: " add email please",
      );
    }
    var byEmail =
        await supabase.from("users").select().eq("email", body["email"]);

    if (byEmail.isNotEmpty) {
      await supabase.auth.resetPasswordForEmail(body['email']);

      return Success().responseMessage(
        message: "check your email to get verify code",
        data: {"email": body['email']},
      );
    }

    return NotFound().responseMessage(message: "email not found !");
  } catch (error) {
    return BadRequest().responseMessage(message: " error !! $error");
  }
}
