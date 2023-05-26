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
      images: ["image 1", "image 2", "image 3"],
    );

    final postId = (await supabase
        .from("posts")
        .insert(postObject.toMap())
        .select("post_id"))[0]["post_id"];

    AnimalModel animalObject = AnimalModel(
      postId: postId,
      name: "boby",
      type: "type",
      breed: "breed",
      color: "black",
      gender: "male",
      age: 6,
      microchipped: true,
      vaccinated: true,
      fixed: false,
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
