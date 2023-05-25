import 'package:shelf_router/shelf_router.dart';
import '../responses/auth_responses/forgot_password_response.dart';
import '../responses/auth_responses/logout_response.dart';
import '../responses/auth_responses/signup_response.dart';
import '../responses/auth_responses/login_response.dart';
import '../responses/auth_responses/update_password_response.dart';
import '../responses/auth_responses/verify_response.dart';

class AuthRouter {
  Router get handler {
    final router = Router()
      ..post("/signup", signupHandler)
      ..post("/verify", verifyHandler)
      ..post("/login", loginHandler)
      ..post("/forgot_password", forgotPasswordHandler)
      ..put("/update_password", updatePasswordHandler)
      ..get("/logout", logoutHandler);

    return router;
  }
}
