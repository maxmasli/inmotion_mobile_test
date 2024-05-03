import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/themes.dart';
import 'package:inmotion_mobile_test/router/app_route.dart';

class App extends StatelessWidget {
  App({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp.router(
        theme: createLightTheme(),
        routerConfig: _appRouter.config(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
