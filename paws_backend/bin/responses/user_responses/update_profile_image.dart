import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

import '../../response_messages/bad_request.dart';
import '../../response_messages/success.dart';
import '../../services/supabase/supabase_env.dart';

updateProfileImage(Request req) async {
  try {
    final byte = await req.read().expand((element) => element).toList();
    final userInfo = JWT.decode(req.headers["authorization"]!);
    final image = await createImage(byte: byte);
    final hasImage = await checkImageProfile(idAuth: userInfo.payload["sub"]);
    final url = await uploadImage(
      file: image,
      found: hasImage,
      id: userInfo.payload["sub"],
    );
    await image.delete();
    await sendURL(url: url, idAuth: userInfo.payload["sub"]);

    return Success().responseMessage(message: "upload done");
  } catch (error) {
    print(error);

    return BadRequest().responseMessage(message: "something went wrong");
  }
}

//create image inside project directory then return file
Future<File> createImage({required List<int> byte}) async {
  final file = File("bin/image/test.png");
  await file.writeAsBytes(byte);

  return file;
}

//check if user has image in supabase storage then return boolean

checkImageProfile({required String idAuth}) async {
  final listImage = await SupabaseEnv()
      .supabase
      .storage
      .from("imageProfile")
      .list(path: "images");
  for (var element in listImage) {
    print(element.name);
    if (element.name.contains(idAuth)) {
      print("-----checkImageProfile---");

      return true;
    }
  }
  print("-----checkImageProfile---");

  return false;
}

//create function for upload image to supabase then return url

uploadImage({
  required bool found,
  required File file,
  required String id,
}) async {
  final supabase = SupabaseEnv().supabase.storage.from("imageProfile");
  if (found) {
    await supabase.update('images/$id.png', file);
  } else {
    await supabase.upload('images/$id.png', file);
  }
  final url = supabase.getPublicUrl('images/$id.png');
  print("-----uploadImage---");

  return url;
}

//send url to table image in database

sendURL({required String url, required String idAuth}) async {
  final supabase = SupabaseEnv().supabase.from("users");

  final result = await supabase.update({"image": url}).eq("auth_id", idAuth);
  print("-----sendURL---");

  return result;
}

//for delete image from server

deleteImageProfile({required String imageName}) async {
  await SupabaseEnv()
      .supabase
      .storage
      .from("imageProfile")
      .remove(["images/$imageName"]);
}
