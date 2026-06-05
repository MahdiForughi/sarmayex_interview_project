import 'package:go_router/go_router.dart';
import 'package:sarmayex_interview_project/app/features/market/presentation/pages/markets_page.dart';

import 'app_middleware.dart';

class AppRouter {
  static final router = GoRouter(
    debugLogDiagnostics: true,
    redirect: AppMiddleware.checkAuth,
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const MarketsPage(),
      ),
    ],
  );
}
