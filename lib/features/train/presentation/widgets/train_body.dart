import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inmotion_mobile_test/core/presentation/app_logs_controller.dart';
import 'package:inmotion_mobile_test/core/presentation/app_timer_controller.dart';
import 'package:inmotion_mobile_test/core/presentation/app_timer_widget.dart';
import 'package:inmotion_mobile_test/di.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/end_train_widgets/end_train_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/prepare_train_widgets/prepare_train_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/running_train_widgets/running_train_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/status_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/train_history_sheet.dart';
import 'package:provider/provider.dart';

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
    final model = context.read<TrainModel>();
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Selector<TrainModel, SystemStatus>(
                      selector: (context, model) => model.systemStatus,
                      shouldRebuild: (prev, next) => prev != next,
                      builder: (context, systemStatus, child) {
                        return AppTimerWidget(
                          isEnabled: systemStatus == SystemStatus.ready ||
                              systemStatus == SystemStatus.rec,
                          controller: appTimerController,
                          onStartPressed: () {
                            appTimerController.startTimer();
                            model.startRecording();
                          },
                          onStopPressed: () {
                            appTimerController.stopTimer();
                            model.stopRecording();
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  const StatusWidget(),
                ],
              ),
              const SizedBox(height: 16),
              Selector<TrainModel, TrainStage>(
                selector: (context, model) => model.trainStage,
                shouldRebuild: (prev, next) => prev != next,
                builder: (context, trainStage, child) {
                  return switch (trainStage) {
                    TrainStage.prepare => const PrepareTrainWidget(),
                    TrainStage.running => const RunningTrainWidget(),
                    TrainStage.end => const EndTrainWidget(),
                  };
                },
              ),
              // Отступ для TrainHistorySheet
              SizedBox(
                height:
                    MediaQuery.of(context).size.height * bottomSheetMinHeight,
              ),
            ],
          ),
          TrainHistorySheet(key: sheetKey),
        ],
      ),
    );
  }
}
