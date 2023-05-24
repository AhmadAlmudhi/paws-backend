import 'package:shelf_router/shelf_router.dart';

import '../../responses/post_responses/comments_responses/add_comment_response.dart';
import '../../responses/post_responses/comments_responses/delete_comment_response.dart';
import '../../responses/post_responses/comments_responses/get_comments_number_response.dart';
import '../../responses/post_responses/comments_responses/read_comments_response.dart';
import '../../responses/post_responses/comments_responses/reply_comment_response.dart';

class CommentsRouter {
  Router get handler {
    final router = Router()
      ..post("/add", addCommentHandler)
      ..get('/read>', readCommentsHandler)
      ..get('/get_number>', getCommentsNumberHandler)
      ..post("/reply", replyCommentHandler)
      ..delete("delete/<id>", deleteCommentHandler);

    return router;
  }
}
