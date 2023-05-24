import 'dart:convert';
import 'package:shelf/shelf.dart';

class Unauthorized {
  responseMessage({required String message}) {
    return Response.unauthorized(
      json.encode({"Message": message, 'Status code': 401}),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
