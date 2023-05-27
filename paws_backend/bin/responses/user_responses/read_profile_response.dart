import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

import '../../response_messages/bad_request.dart';
import '../../response_messages/success.dart';
import '../../services/supabase/supabase_env.dart';

readProfileHandler(Request req) async{
  try{
    final header = req.headers;

  final jwt = JWT.decode(header['authorization']!.toString().trim());

  final user = (await SupabaseEnv()
      .supabase
      .from("user")
      .select()
      .eq("authId", jwt.payload["sub"]))[0];

      return Success().responseMessage(message: 'here is your profile', data: user);
  }catch(error){
    print(error);

    return BadRequest().responseMessage(message: "something went wrong");
  }
}
