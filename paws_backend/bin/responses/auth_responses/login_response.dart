import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../response_messages/bad_request.dart';
import '../../response_messages/success.dart';
import '../../services/supabase/supabase_env.dart';

Future<Response> loginHandler(Request req) async {
//login and take the token to check in middleware
  try {
    final body = json.decode(await req.readAsString());

//Ensure that information is entered
    if (body["email"] == null || body["password"] == null) {
      return Response.badRequest(body: "please add email and password ");
    }

    final auth = SupabaseEnv().supabase.auth;
    final userLogin = await auth.signInWithPassword(
      email: body["email"],
      password: body["password"],
    );

    return Success().responseMessage(
      message: "you login successfully  ",
      data: {"TOKEN": userLogin.session?.accessToken},
    );
  } catch (error) {
    return BadRequest().responseMessage(message: "login error !");
  }
}
