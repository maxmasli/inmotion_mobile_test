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
    required this.onPausePressed,
  });

  final AppTimerController controller;
  final VoidCallback onStartPressed;
  final VoidCallback onStopPressed;
  final VoidCallback onPausePressed;

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
                      Text(
                        controller.formattedTime,
                        style: theme.textTheme.headlineLarge,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          TimerIcon(
                            onTap: switch (controller.state) {
                              TimerState.stopped => onStartPressed,
                              TimerState.running => null,
                              TimerState.paused => onStartPressed,
                            },
                            svgPath: AppIcons.play,
                          ),
                          const SizedBox(width: 15),
                          TimerIcon(
                            onTap: switch (controller.state) {
                              TimerState.stopped => null,
                              TimerState.running => onPausePressed,
                              TimerState.paused => onStopPressed,
                            },
                            // В случае если нажата пауза, то берется иконка стоп
                            // В других случаях иконка паузы
                            svgPath: controller.state == TimerState.paused
                                ? AppIcons.stop
                                : AppIcons.pause,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  height: 36,
                  decoration: BoxDecoration(
                    color: switch (controller.state) {
                      TimerState.stopped => AppColors.green,
                      TimerState.running => AppColors.blue.withOpacity(0.3),
                      TimerState.paused => AppColors.blue,
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
                        TimerState.paused => "ПАУЗА",
                      },
                      style: theme.textTheme.labelSmall,
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
  const TimerIcon({super.key, required this.onTap, required this.svgPath});

  final VoidCallback? onTap;
  final String svgPath;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap != null ? 1 : 0.2,
      child: Material(
        color: Colors.transparent,
        shape: const RoundedRectangleBorder(),
        child: InkWell(
          borderRadius: BorderRadius.circular(1000),
          onTap: onTap,
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
