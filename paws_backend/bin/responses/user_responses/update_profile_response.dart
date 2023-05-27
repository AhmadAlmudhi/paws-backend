import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';

import '../../response_messages/bad_request.dart';
import '../../response_messages/success.dart';
import '../../services/supabase/supabase_env.dart';

updateProfileHandler(Request req) async{
   try {
    final Map body = json.decode(await req.readAsString());
    final checkEmail = body.keys.contains("email");
    final supabase = SupabaseEnv().supabase;
    final jwt = JWT.decode(req.headers["authorization"].toString().trim());
    final fromProfile = supabase.from("user");
    
    if (checkEmail) {
      await supabase.auth.admin.updateUserById(
        jwt.payload["sub"],
        attributes: AdminUserAttributes(email: body["email"]),
      );
    }

    final user = await fromProfile
        .select("email, name, bio, phone, whatsapp, country, city, gender, age")
        .eq("authId", jwt.payload["sub"]);

    final updated = await fromProfile
        .update({
          "name": body["name"] ?? user[0]["name"],
          "email": body["email"] ?? user[0]["email"],
          "bio": body["bio"] ?? user[0]["bio"],
          "phone": body["phone"] ?? user[0]["phone"],
          "whatsapp": body["whatsapp"] ?? user[0]["whatsapp"],
          "country": body["country"] ?? user[0]["country"],
          "city": body["city"] ?? user[0]["city"],
          "gender": body["gender"] ?? user[0]["gender"],
          "age": body["age"] ?? user[0]["age"],
        })
        .eq("authId", jwt.payload["sub"])
        .select("username, email, name, bio, phone, whatsapp, country, city, gender, age");

    return Success().responseMessage(
      message: "profile has been updated",
      data: {"updated profile": updated},
    );
  }on RangeError{
    return BadRequest().responseMessage(message: "invalid input");
  }
   catch (error) {
    print(error);

    return BadRequest().responseMessage(message: "something went wrong");
  }
}
