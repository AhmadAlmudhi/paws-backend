import 'dart:convert';
import 'package:shelf/shelf.dart';

class NotFound {
  responseMessage({required String message}) {
    return Response.notFound(
      json.encode({"Message": message, 'Status code': 404}),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
