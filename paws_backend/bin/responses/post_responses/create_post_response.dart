import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import '../../models/animal_model.dart';
import '../../models/post_model.dart';
import '../../response_messages/bad_request.dart';
import '../../response_messages/created.dart';
import '../../services/supabase/supabase_env.dart';

Future<Response> createPostHandler(Request req) async {
  try {
    final body = json.decode(await req.readAsString());
    final supabase = SupabaseEnv().supabase;

    final jwt = JWT.decode(req.headers["authorization"]!);
    final authId = jwt.payload["sub"];

    final userId = ((await supabase
        .from("users")
        .select("user_id")
        .eq("auth_id", authId))[0]["user_id"]);

    PostModel postObject = PostModel(
      userId: userId,
      content: body["content"] ?? "content",
      postType: body["post_type"],
      images: body["images"],
    );

    final postId = (await supabase
        .from("posts")
        .insert(postObject.toMap())
        .select("post_id"))[0]["post_id"];

    AnimalModel animalObject = AnimalModel(
      postId: postId,
      name: body["name"],
      type: body["type"],
      breed: body["breed"],
      color: body["color"],
      gender: body["gender"],
      age: body["age"],
      microchipped: body["microchipped"],
      vaccinated: body["vaccinated"],
      fixed: body["fixed"],
    );

    await supabase.from("animals").insert(animalObject.toMap());

    return Created().responseMessage(
      message: "Post created!",
      data: {
        "post data": [postObject.toMap()],
        "animal data": [animalObject.toMap()],
      },
    );
  } catch (error) {
    return BadRequest().responseMessage(
      message: "sorry error ! $error ",
    );
  }
}
