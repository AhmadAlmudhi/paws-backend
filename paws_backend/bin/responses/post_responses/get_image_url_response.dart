import 'dart:io';
import 'dart:math';

import 'package:shelf/shelf.dart';
import '../../response_messages/bad_request.dart';
import '../../response_messages/success.dart';
import '../../services/supabase/supabase_env.dart';

Future<Response> getImageUrlHandler(Request req) async {
  try {
    final bytes = await req.read().expand((element) => element).toList();

    final file = File("bin/image/test.png");
    await file.writeAsBytes(bytes);

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

    return Success().responseMessage(
      message: "success",
      data: {"url": url},
    );
  } catch (error) {
    return BadRequest().responseMessage(message: "something went wrong");
  }
}
