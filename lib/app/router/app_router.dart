import 'package:go_router/go_router.dart';

import 'app_middleware.dart';

class AppRouter {
  static final router = GoRouter(
    debugLogDiagnostics: true,
    redirect: AppMiddleware.checkAuth,
    routes: [],
  );
}
