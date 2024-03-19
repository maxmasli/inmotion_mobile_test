import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_logs_controller.dart';
import 'package:inmotion_mobile_test/core/presentation/app_timer_controller.dart';
import 'package:inmotion_mobile_test/core/presentation/app_timer_widget.dart';
import 'package:inmotion_mobile_test/di.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_provider.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/prepare_train_widgets/prepare_train_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/running_train_widgets/running_train_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/status_widget.dart';
import 'package:provider/provider.dart';

const bottomSheetMinHeight = 0.15;

class TrainBody extends StatefulWidget {
  const TrainBody({super.key});

  @override
  State<TrainBody> createState() => _TrainBodyState();
}

class _TrainBodyState extends State<TrainBody> {
  final appTimerController = AppTimerController();
  final l = getIt<AppLogsController>();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TrainModel>();
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Stack(
        children: [
          Column(
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

              switch (model.trainStage) {
                TrainStage.prepare => const PrepareTrainWidget(),
                TrainStage.running => const RunningTrainWidget(),
                TrainStage.end => throw UnimplementedError(),
              }
            ],
          ),

          DraggableScrollableSheet(
            initialChildSize: bottomSheetMinHeight,
            minChildSize: bottomSheetMinHeight,
            maxChildSize: 0.8,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  color: Colors.red,
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      for (final i in List.generate(100, (i) => i)) ...[
                        Text('something №$i')
                      ]
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
