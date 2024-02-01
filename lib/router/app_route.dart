import 'package:auto_route/auto_route.dart';
import 'package:inmotion_mobile_test/router/app_route.gr.dart';
import 'package:inmotion_mobile_test/router/guards/auth_guard.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: AuthRoute.page, path: '/auth'),
        AutoRoute(
          page: MainRoute.page,
          path: '/main',
          initial: true,
          guards: [
            AuthGuard(),
          ],
        ),
      ];
}
