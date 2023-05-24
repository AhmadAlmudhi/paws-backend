import 'dart:convert';
import 'package:shelf/shelf.dart';

class Created {
  responseMessage({required String message, Map? data}) {
    return Response(
      201,
      body: json.encode(
        {"Message": message, 'Status code': 201, ...data ?? {}},
      ).toString(),
      headers: {'content-type': 'application/json'},
    );
  }
}
