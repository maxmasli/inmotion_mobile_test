import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/utils/utils.dart';
import 'package:inmotion_mobile_test/features/auth/presentation/widgets/mobile/auth_body.dart'
    as mobile;
import 'package:inmotion_mobile_test/features/auth/presentation/widgets/tablet/auth_body.dart'
    as tablet;

@RoutePage()
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key, required this.onResult});

  final Function(bool) onResult;

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= minTabletSize;
    return Scaffold(
      body: isTablet
          ? tablet.AuthBody(onResult: onResult)
          : mobile.AuthBody(onResult: onResult),
    );
  }
}
