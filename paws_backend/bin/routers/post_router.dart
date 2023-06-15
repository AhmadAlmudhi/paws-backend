import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../middlewares/check_token_middleware.dart';
import '../responses/post_responses/create_post_response.dart';
import '../responses/post_responses/delete_post_response.dart';
import '../responses/post_responses/toggle_favorite_response.dart';
import '../responses/post_responses/read_all_posts_response.dart';
import '../responses/post_responses/read_post_response.dart';
import '../responses/post_responses/share_post_response.dart';

class PostRouter {
  Handler get handler {
    final router = Router()
      ..post("/create", createPostHandler)
      ..get("/read_all", readAllPostsHandler)
      ..get("/read/<post_id>", readPostHandler)
      ..delete('/delete/<post_id>', deletePostHandler)
      ..get("/share/<post_id>", sharePostHandler)
      ..post("/toggle_favorite/<post_id>", toggleFavoriteHandler);
    final pipline =
        Pipeline().addMiddleware(checkTokenMiddleware()).addHandler(router);

    return pipline;
  }
}
