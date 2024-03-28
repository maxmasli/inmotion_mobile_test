import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inmotion_mobile_test/core/colors.dart';
import 'package:inmotion_mobile_test/core/presentation/app_timer_controller.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';
import 'package:provider/provider.dart';

class AppTimerWidget extends StatelessWidget {
  const AppTimerWidget({
    super.key,
    required this.controller,
    required this.onStartPressed,
    required this.onStopPressed,
    this.isEnabled = true,
  });

  final AppTimerController controller;

  /// Если [isEnabled] == true, то будут активны кнопки старт и стоп
  /// и соответственно будут вызываться методы [onStartPressed] и [onStopPressed]
  /// Если таймер идет, и [isEnabled] == false, то таймер продолжает работать
  /// и кнопки старт и стоп доступны
  final bool isEnabled;

  final VoidCallback onStartPressed;
  final VoidCallback onStopPressed;

  // Widget height is 86
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RepaintBoundary(
      child: ChangeNotifierProvider.value(
        value: controller,
        child: Consumer<AppTimerController>(
          builder: (context, controller, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 50,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      Opacity(
                        opacity: (controller.isRunning || isEnabled) ? 1 : 0.2,
                        child: Text(
                          controller.formattedTime,
                          style: theme.textTheme.headlineLarge,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          TimerIcon(
                            onTap: switch (controller.state) {
                              TimerState.stopped => onStartPressed,
                              TimerState.running => null,
                            },
                            svgPath: AppIcons.play,
                            isTimerEnabled: (controller.isRunning || isEnabled),
                          ),
                          const SizedBox(width: 15),
                          TimerIcon(
                            onTap: switch (controller.state) {
                              TimerState.stopped => null,
                              TimerState.running => onStopPressed,
                            },
                            svgPath: AppIcons.stop,
                            isTimerEnabled: (controller.isRunning || isEnabled),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Opacity(
                  opacity: (controller.isRunning || isEnabled) ? 1 : 0.2,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
                    height: 36,
                    decoration: BoxDecoration(
                      color: switch (controller.state) {
                        TimerState.stopped => AppColors.green,
                        TimerState.running => AppColors.blue.withOpacity(0.3),
                      },
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        switch (controller.state) {
                          TimerState.stopped => "Начните тренировку",
                          TimerState.running => "Идет тренировка",
                        },
                        style: theme.textTheme.labelSmall,
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class TimerIcon extends StatelessWidget {
  const TimerIcon({
    super.key,
    required this.onTap,
    required this.svgPath,
    required this.isTimerEnabled,
  });

  final VoidCallback? onTap;
  final String svgPath;
  final bool isTimerEnabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap != null && isTimerEnabled ? 1 : 0.2,
      child: Material(
        color: Colors.transparent,
        shape: const RoundedRectangleBorder(),
        child: InkWell(
          borderRadius: BorderRadius.circular(1000),
          onTap: isTimerEnabled ? onTap : null,
          child: Ink(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              svgPath,
              width: 32,
              height: 32,
            ),
          ),
        ),
      ),
    );
  }
}
