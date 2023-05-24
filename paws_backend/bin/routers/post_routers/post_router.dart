import 'package:shelf_router/shelf_router.dart';

import '../../responses/post_responses/add_post_response.dart';
import '../../responses/post_responses/delete_post_response.dart';
import '../../responses/post_responses/read_all_posts_response.dart';
import '../../responses/post_responses/read_post_response.dart';
import '../../responses/post_responses/share_post_response.dart';
import 'comments_router.dart';
import 'favorites_router.dart';

class PostRouter {
  Router get handler {
    final router = Router()
      ..post("/create", addPostHandler)
      ..get("/read_all", readAllPostsHandler)
      ..get("/read/<id>", readPostHandler)
      ..delete('/delete/<id>', deletePostHandler)
      ..get("/share", sharePostHandler)
      ..mount("/favorites", FavoritesRouter().handler)
      ..mount("/comments", CommentsRouter().handler);

    return router;
  }
}
