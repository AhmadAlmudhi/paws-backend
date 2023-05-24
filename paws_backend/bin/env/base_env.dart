import 'dart:io';

class BaseEnv {
  get ip {
    return InternetAddress.anyIPv4;
  }

  get port {
    return int.parse(Platform.environment['PORT'] ?? '8080');
  }
}
