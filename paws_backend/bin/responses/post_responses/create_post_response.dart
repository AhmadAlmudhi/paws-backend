import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import '../../models/animal_model.dart';
import '../../models/post_model.dart';
import '../../response_messages/bad_request.dart';
import '../../response_messages/created.dart';
import '../../services/supabase/supabase_env.dart';
import 'dart:io';
import 'dart:math';

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

    List images = body["images"];
    List imagesLinks = [];

    for (var image in images) {
      String link = await uploadImage(byte: image);
      imagesLinks.add(link);
    }

    PostModel postObject = PostModel(
      userId: userId,
      content: body["content"] ?? "content",
      postType: body["post_type"],
      images: imagesLinks,
      status: body["post_type"] == "offer" ? "not adopted" : "requested",
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

//-------------------------------------------

Future<String> uploadImage({required List<int> byte}) async {
  final file = File("bin/image/test.png");
  await file.writeAsBytes(byte);

  int random = 1 + Random().nextInt((1000000000 + 1) - 1);

  await SupabaseEnv()
      .supabase
      .storage
      .from("imageProfile")
      .upload('images/$random.png', file);

  final url = SupabaseEnv()
      .supabase
      .storage
      .from("imageProfile")
      .getPublicUrl('images/$random.png');

  return url;
}
