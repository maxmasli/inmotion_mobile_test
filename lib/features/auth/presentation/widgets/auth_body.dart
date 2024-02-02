import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inmotion_mobile_test/core/presentation/app_button.dart';
import 'package:inmotion_mobile_test/core/presentation/app_text_field.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';

class AuthBody extends StatefulWidget {
  const AuthBody({super.key, required this.onResult});

  final Function(bool) onResult;

  @override
  State<AuthBody> createState() => _AuthBodyState();
}

class _AuthBodyState extends State<AuthBody> {
  var showBottomContainer = true;

  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  void _checkAuth() {
    final login = loginController.text.trim();
    final password = loginController.text.trim();
    widget.onResult(login == 'log' && password == 'pas');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final containerHeight = MediaQuery.of(context).size.height / 1.5;
    return ColoredBox(
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 80),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: SvgPicture.asset(AppIcons.logo),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      AppTextField(
                        leading: Text(
                          "Логин",
                          style: theme.textTheme.titleMedium,
                        ),
                        controller: loginController,
                      ),
                      const Divider(),
                      AppTextField(
                        leading: Text(
                          "Пароль",
                          style: theme.textTheme.titleMedium,
                        ),
                        obscureText: true,
                        controller: passwordController,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                AppButton(
                  onTap: () {
                    _checkAuth();
                  },
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(16),
                  padding: const EdgeInsets.all(18.5),
                  child: Center(
                    child: Text(
                      "Войти",
                      style: theme.textTheme.labelLarge,
                    ),
                  ),
                ),
                const Spacer()
              ],
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              bottom: showBottomContainer ? 0 : -containerHeight,
              child: Container(
                height: containerHeight,
                width: MediaQuery.of(context).size.width - 16 * 2,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 112),
                      Text(
                        "Добро пожаловать",
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Начало работы с учетной записью',
                        style: theme.textTheme.displayLarge,
                      ),
                      const SizedBox(height: 45),
                      AppButton(
                        onTap: () {
                          showBottomContainer = false;
                          setState(() {});
                        },
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(16),
                        padding: const EdgeInsets.all(18.5),
                        child: Center(
                          child: Text(
                            "Войти",
                            style: theme.textTheme.labelLarge,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
