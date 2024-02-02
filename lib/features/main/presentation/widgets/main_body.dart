import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/core/presentation/app_logs_controller.dart';
import 'package:inmotion_mobile_test/features/main/presentation/widgets/logs_widget.dart';
import 'package:inmotion_mobile_test/core/presentation/app_timer_controller.dart';
import 'package:inmotion_mobile_test/core/presentation/app_timer_widget.dart';
import 'package:inmotion_mobile_test/di.dart';
import 'package:inmotion_mobile_test/features/main/presentation/provider/main_provider.dart';
import 'package:inmotion_mobile_test/features/main/presentation/widgets/legend_widget.dart';
import 'package:inmotion_mobile_test/features/main/presentation/widgets/status_widget.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';
import 'package:provider/provider.dart';

class MainBody extends StatefulWidget {
  const MainBody({super.key});

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  final appTimerController = AppTimerController();
  final l = getIt<AppLogsController>();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MainModel>();
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AppTimerWidget(
                  controller: appTimerController,
                  onStartPressed: () {
                    appTimerController.startTimer();
                    model.startRecording();
                  },
                  onStopPressed: () {
                    appTimerController.stopTimer();
                    model.stopRecording();
                  },
                  onPausePressed: () {
                    appTimerController.pauseTimer();
                    model.pauseRecording();
                  },
                ),
              ),
              const SizedBox(width: 16),
              const StatusWidget(),
            ],
          ),
          const SizedBox(height: 16),
          const LegendWidget(),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, i) {
                return Text("asdasd");
              },
            ),
          ),
          LogsWidget(controller: l),
        ],
      ),
    );
  }
}
