import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../middlewares/check_token_middleware.dart';
import '../responses/user_responses/read_profile_response.dart';
import '../responses/user_responses/read_favorites_response.dart';
import '../responses/user_responses/update_profile_response.dart';

class UserRouter {
  Handler get handler {
    final router = Router()
      ..get("/read_profile", readProfileHandler)
      ..put("/update_profile", updateProfileHandler)
      ..get("/read_favorites", readFavoritesHandler);

    final pipline =
        Pipeline().addMiddleware(checkTokenMiddleware()).addHandler(router);

    return pipline;
  }
}
