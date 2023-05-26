import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../responses/base_responses/root_response.dart';
import 'auth_router.dart';
import 'post_routers/post_router.dart';
import 'user_router.dart';

class BaseRouter {
  Router get handler {
    final router = Router()
      ..get('/', rootHandler)
      ..mount("/auth", AuthRouter().handler)
      ..mount("/user", UserRouter().handler)
      ..mount("/post", PostRouter().handler)
      ..all('/<name|.*>', (Request _) {
        return Response.notFound("Route not found please change your route!");
      });

    return router;
  }
}
