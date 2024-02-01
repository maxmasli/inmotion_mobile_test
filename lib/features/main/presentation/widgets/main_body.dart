import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_timer_controller.dart';
import 'package:inmotion_mobile_test/core/presentation/app_timer_widget.dart';
import 'package:inmotion_mobile_test/features/main/presentation/provider/main_provider.dart';
import 'package:provider/provider.dart';

class MainBody extends StatefulWidget {
  const MainBody({super.key});

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  final appTimerController = AppTimerController();

  @override
  Widget build(BuildContext context) {
    final model = context.read<MainModel>();
    return Column(
      children: [
        AppTimerWidget(
          controller: appTimerController,
          onStartPressed: () {
            appTimerController.startTimer();
            model.startRecording();
          },
          onStopPressed: () {
            appTimerController.stopTimer();
            model.stopRecording();
          },
        )
      ],
    );
  }
}
