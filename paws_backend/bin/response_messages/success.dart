import 'dart:convert';
import 'package:shelf/shelf.dart';

class Success {
  responseMessage({required String message, Map? data}) {
    return Response.ok(
      json.encode({"Message": message, 'Status code': 200, ...data ?? {}}),
      headers: {'content-type': 'application/json'},
    );
  }
}
