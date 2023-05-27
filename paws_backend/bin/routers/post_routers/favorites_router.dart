import 'package:shelf_router/shelf_router.dart';
import '../../responses/post_responses/favorites_responses/get_favorites_number_response.dart';
import '../../responses/post_responses/favorites_responses/toggle_favorite_response.dart';

class FavoritesRouter {
  Router get handler {
    final router = Router()
      ..post("/toggle/<post_id>", toggleFavoriteHandler)
      ..get('/get_number/<post_id>', getFavoritesNumberHandler);

    return router;
  }
}
