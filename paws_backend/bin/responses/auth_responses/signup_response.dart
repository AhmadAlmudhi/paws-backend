import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';
import '../../Model/UserModel.dart';
import '../../response_messages/bad_request.dart';
import '../../response_messages/created.dart';
import '../../services/supabase/supabase_env.dart';

Future<Response> signupHandler(Request req) async {
  try {
    final body = json.decode(await req.readAsString());
    final supabaseVariable = SupabaseEnv().supabase.auth;
    final supabase = SupabaseEnv().supabase.from("users").select();

    // check if the user has entered valid values.
    if (body.keys.toString() != "(username, email, password, name, phone)") {
      return BadRequest().responseMessage(message: "Invalid input!");
    }

//Checking if the email and username are registered before
    var checkemail = await supabase.eq("email", body["email"]);
    var checkuser = await supabase.eq("username", body["username"]);

    if (checkemail.isNotEmpty) {
      return BadRequest().responseMessage(
        message: "email address has already been registered ",
      );
    }

    if (checkuser.isNotEmpty) {
      return BadRequest().responseMessage(
        message: "username has already been registered ",
      );
    }

    UserResponse info = await supabaseVariable.admin.createUser(
      AdminUserAttributes(
        email: body["email"],
        password: body["password"],
      ),
    );

    final idAuth = info.user?.id;
    UserModel userObject = UserModel(
      username: body["name"]!,
      name: body["name"]!,
      email: info.user!.email!,
      authId: idAuth,
      phone: body["phone"]!,
    );

    await SupabaseEnv()
        .supabase
        .from("users")
        .insert(userObject.profileToMap());

    final result = await SupabaseEnv()
        .supabase
        .from("users")
        .select("user_id")
        .eq("email", body["email"]);

    final iduser = result[0]["user_id"];

    await SupabaseEnv()
        .supabase
        .from("details")
        .insert({"user_id": iduser, ...userObject.detailsToMap()});

    await SupabaseEnv().supabase.from("contacts").insert([
      {"user_id": iduser, ...userObject.contactToMap()},
    ]);

    await supabaseVariable.signInWithOtp(email: body["email"]);

    return Created().responseMessage(
      message: "create account page ",
      data: {
        "name": body["name"],
        "user ID": idAuth,
      },
    );
  } on AuthException {
    return BadRequest().responseMessage(
      message: "sorry error ! $AuthException ",
    );
  }
}
