import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_timer_controller.dart';
import 'package:provider/provider.dart';

class AppTimerWidget extends StatelessWidget {
  const AppTimerWidget({
    super.key,
    required this.controller,
    required this.onStartPressed,
    required this.onStopPressed,
  });

  final AppTimerController controller;
  final VoidCallback onStartPressed;
  final VoidCallback onStopPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const enabledColor = Colors.green;
    final disabledColor = Colors.grey.withOpacity(0.5);
    return RepaintBoundary(
      child: ChangeNotifierProvider.value(
        value: controller,
        child: Consumer<AppTimerController>(
          builder: (context, controller, _) {
            return Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Opacity(
                    opacity: controller.state != TimerState.running ? 0.2 : 1,
                    child: Text(
                      controller.formattedTime,
                      style: theme.textTheme.headlineLarge,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: controller.state != TimerState.running
                            ? onStartPressed
                            : null,
                        icon: const Icon(Icons.play_arrow),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: controller.state != TimerState.stopped
                            ? onStopPressed
                            : null,
                        icon: const Icon(Icons.stop_circle),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
