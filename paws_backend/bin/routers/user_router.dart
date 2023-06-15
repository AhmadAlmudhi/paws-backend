import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../middlewares/check_token_middleware.dart';
import '../responses/user_responses/update_profile_image.dart';
import '../responses/user_responses/get_user_response.dart';
import '../responses/user_responses/read_favorites_response.dart';
import '../responses/user_responses/update_profile_response.dart';

class UserRouter {
  Handler get handler {
    final router = Router()
      ..get("/get_user/<id>", getUserHandler)
      ..put("/update_profile", updateProfileHandler)
      ..get("/read_favorites", readFavoritesHandler)
      ..put("/update_image", updateProfileImage);

    final pipline =
        Pipeline().addMiddleware(checkTokenMiddleware()).addHandler(router);

    return pipline;
  }
}
