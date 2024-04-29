import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inmotion_mobile_test/core/presentation/app_button.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/core/presentation/app_text_field.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';

class AuthBody extends StatefulWidget {
  const AuthBody({super.key, required this.onResult});

  final Function(bool) onResult;

  @override
  State<AuthBody> createState() => _AuthBodyState();
}

class _AuthBodyState extends State<AuthBody> {
  var _showWelcome = true;

  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  // TODO вынести эту логику в provider
  void _checkAuth() {
    final login = _loginController.text.trim();
    final password = _passwordController.text.trim();
    final isAuth = login == 'Sporttech' && password == 'Demo2024';
    if (isAuth) {
      widget.onResult(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.colorScheme.secondaryContainer,
      child: Row(
        children: [
          const Spacer(),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LayoutBuilder(builder: (context, constraints) {
                  return SvgPicture.asset(
                    AppIcons.logo,
                    width: constraints.maxWidth,
                  );
                }),
                const SizedBox(height: 36),
                Row(
                  children: [
                    Expanded(
                      child: AppContainer(
                        borderRadius: BorderRadius.circular(8),
                        child: AppTextField(
                          leading: Text(
                            "Логин",
                            style: theme.textTheme.titleMedium,
                          ),
                          controller: _loginController,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppContainer(
                        borderRadius: BorderRadius.circular(8),
                        child: AppTextField(
                          leading: Text(
                            "Пароль",
                            style: theme.textTheme.titleMedium,
                          ),
                          obscureText: true,
                          controller: _passwordController,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AppButton(
                  onTap: () {
                    _checkAuth();
                  },
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(8),
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      "Войти",
                      style: theme.textTheme.labelLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
