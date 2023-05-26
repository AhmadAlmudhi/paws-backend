import 'package:shelf_router/shelf_router.dart';
import '../../responses/post_responses/favorites_responses/add_to_favorites_response.dart';
import '../../responses/post_responses/favorites_responses/get_favorites_number_response.dart';
import '../../responses/post_responses/favorites_responses/remove_from_favorites_response.dart';

class FavoritesRouter {
  Router get handler {
    final router = Router()
      ..post("/add/<post_id>", addToFavoritesHandler)
      ..delete("/remove/<post_id>", removeFromFavoritesHandler)
      ..get('/get_number/<post_id>', getFavoritesNumberHandler);

    return router;
  }
}
