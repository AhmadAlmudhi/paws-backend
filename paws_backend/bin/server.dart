import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_helmet/shelf_helmet.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'env/base_env.dart';
import 'routers/base_router.dart';

void main() {
  withHotreload(() => createServer());
}

Future<HttpServer> createServer() async {
  final handler = Pipeline()
      .addMiddleware(helmet())
      .addMiddleware(logRequests())
      .addHandler(BaseRouter().handler);
  final server = await serve(handler, BaseEnv().ip, BaseEnv().port);
  print('Server listening on http://${server.address.host}:${server.port}');

  return server;
}
