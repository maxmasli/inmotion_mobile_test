import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_timer_controller.dart';
import 'package:inmotion_mobile_test/core/presentation/app_timer_widget.dart';
import 'package:inmotion_mobile_test/core/presentation/keyboard_listener.dart'
    as kl;
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
  final _appTimerController = AppTimerController();

  final _keyboardListener = kl.KeyboardListener();
  var _isShowKeyboard = false;

  @override
  void initState() {
    _keyboardListener.addListener(onChange: (isVisible) {
      setState(() {
        _isShowKeyboard = isVisible;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<TrainModel>();

    // Для корректного отступа для BottomSheet
    final keyboardHeight =
        MediaQuery.of(Scaffold.of(context).context).viewInsets.bottom;

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
                          controller: _appTimerController,
                          onStartPressed: () {
                            _appTimerController.startTimer();
                            model.startRecording();
                          },
                          onStopPressed: () {
                            _appTimerController.stopTimer();
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
                height: (MediaQuery.of(context).size.height - keyboardHeight) *
                    bottomSheetMinHeight,
              ),
            ],
          ),
          TrainHistorySheet(),
        ],
      ),
    );
  }
}
