import 'dart:convert';
import 'package:shelf/shelf.dart';

class BadRequest {
  responseMessage({required String message}) {
    return Response.badRequest(
      body: json.encode({"Message": message, 'Status code': 400}),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
