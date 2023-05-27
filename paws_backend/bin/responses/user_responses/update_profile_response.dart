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
    final userAuth = jwt.payload["sub"];
    final fromProfile = supabase.from("users");
    final fromDetails = supabase.from("details");
    final fromContact =supabase.from("contacts");
    
    if (checkEmail) {
      await supabase.auth.admin.updateUserById(
        jwt.payload["sub"],
        attributes: AdminUserAttributes(email: body["email"]),
      );
    }
// get old user va
    final user = await fromProfile
        .select("email, name, bio")
        .eq("auth_id", jwt.payload["sub"]);

   final id = await fromProfile.select("user_id").eq("auth_id", userAuth);
        
   final details = await fromDetails.select("phone, country, city,gender,age")
        .eq("user_id", id[0]["user_id"]);

   final contacts = await fromContact .select("phone, whatsapp, email")
        .eq("user_id", id[0]["user_id"]);

   final updatedUser = await fromProfile
        .update({
          "name": body["name"] ?? user[0]["name"],
          "email": body["email"] ?? user[0]["email"],
          "bio": body["bio"] ?? user[0]["bio"],})
        .eq("auth_id", jwt.payload["sub"])
        .select("username, email, name, bio");

   final updatedDetails = await fromDetails
        .update({
          "phone": body["phone"] ?? details[0]["phone"],
          "country": body["country"] ?? details[0]["country"],
          "city": body["city"] ?? details[0]["city"],
          "gender": body["gender"] ?? details[0]["gender"],
          "age": body["age"] ?? details[0]["age"],})
        .eq("user_id", id[0]["user_id"])
        .select("phone, country, city,gender,age");

   final updatedContact = await fromContact
        .update({
          "phone": body["phone"] ?? contacts[0]["phone"],
          "whatsapp": body["whatsapp"] ?? contacts[0]["whatsapp"],
          "email": body["email"] ?? contacts[0]["email"],})
        .eq("user_id", id[0]["user_id"])
        .select("phone, whatsapp, email");

   Map userMap = {
      ...updatedUser[0],...updatedDetails[0],
      "contact": updatedContact,
    };

    return Success().responseMessage(
      message: "profile has been updated",data: userMap,);
  }on RangeError{
    return BadRequest().responseMessage(message: "invalid input");
  }
   catch (error) {
    print(error);

    return BadRequest().responseMessage(message: "something went wrong");
  }
}
