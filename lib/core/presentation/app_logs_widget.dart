import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_logs_controller.dart';
import 'package:provider/provider.dart';

class AppLogsWidget extends StatelessWidget {
  const AppLogsWidget({super.key, required this.controller});

  final AppLogsController controller;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<AppLogsController>(
        builder: (context, controller, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: controller.logs.map((log) => Text(log)).toList(),
          );
        },
      ),
    );
  }
}
