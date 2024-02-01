import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:inmotion_mobile_test/router/app_route.gr.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    const authenticated = true;
    log("Check auth");
    if (authenticated) {
      resolver.next(true);
      log("Authenticated!");
    } else {
      log("Go to Auth screen");
      resolver.redirect(AuthRoute(onResult: (success) {
        resolver.next(success);
      }));
    }
  }
}