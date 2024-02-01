import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/features/auth/presentation/widgets/auth_body.dart';

@RoutePage()
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key, required this.onResult});

  final Function(bool) onResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBody(onResult: onResult),
    );
  }
}
