import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import '../response_messages/unauthorized.dart';
import '../services/supabase/supabase_env.dart';

Middleware checkTokenMiddleware() => (innerhandler) => (Request req) {
      try {
        if (!req.headers.containsKey("authorization")) {
          return Unauthorized().responseMessage(
            message: "You need a token to access this endpoint!",
          );
        }

        final token = req.headers['authorization'].toString().trim();

        JWT.verify(
          token,
          SecretKey(
            SupabaseEnv().jwt,
          ),
        );

        return innerhandler(req);
      } on JWTExpiredError catch (error) {
        return Unauthorized().responseMessage(message: error.message);
      } on JWTError catch (error) {
        return Unauthorized().responseMessage(message: error.message);
      } catch (error) {
        return Unauthorized().responseMessage(
          message: "Something went wrong with the token!",
        );
      }
    };
