import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:inmotion_mobile_test/core/presentation/app_logs_controller.dart';
import 'package:inmotion_mobile_test/di.dart';
import 'package:inmotion_mobile_test/router/app_route.gr.dart';

class AuthGuard extends AutoRouteGuard {

  final l = getIt<AppLogsController>();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    const authenticated = true;
    l.log("Check auth", 'AUTH');
    if (authenticated) {
      resolver.next(true);
      l.log("Authenticated!", 'AUTH');
    } else {
      l.log("Go to Auth screen");
      resolver.redirect(AuthRoute(onResult: (success) {
        resolver.next(success);
      }));
    }
  }
}