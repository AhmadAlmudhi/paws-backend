import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

import '../../response_messages/bad_request.dart';
import '../../response_messages/success.dart';
import '../../services/supabase/supabase_env.dart';

readFavoritesHandler(Request req) async{
  try{
  final header = req.headers;

  final jwt = JWT.decode(header['authorization']!.toString().trim());
  final supabase = SupabaseEnv().supabase;
  final userAuth = jwt.payload["sub"];

  final id =
      (await supabase.from("users").select("favorites").eq("auth_id", userAuth))[0];
  final List favindex= id["favorites"];
      print(favindex.length);

      List post=[];
      List animal=[];
      Map favorite ={};

      for(int i=0;i<favindex.length;i++){
  final readPost = await supabase
      .from("posts")
      .select()
      .eq("post_id", favindex[i]);

  final readAnimals = await supabase
      .from("animals")
      .select()
      .eq("post_id", favindex[i]);
      post.add(readPost);
      animal.add(readAnimals);
      favorite[i]={...post+animal};}

      return Success().responseMessage(message: 'your favorites posts', data:{"favorites":favorite.toString()} );
  }catch(error){
    print(error);
    
    return BadRequest().responseMessage(message: "something went wrong");
  }
}
