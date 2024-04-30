import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_timer_controller.dart';
import 'package:inmotion_mobile_test/core/presentation/app_timer_widget.dart';
import 'package:inmotion_mobile_test/core/presentation/status_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/device_info_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/satellite_info_widget.dart';
import 'package:provider/provider.dart';

class TopBarWidget extends StatefulWidget {
  const TopBarWidget({super.key});

  @override
  State<TopBarWidget> createState() => _TopBarWidgetState();
}

class _TopBarWidgetState extends State<TopBarWidget> {

  final _appTimerController = AppTimerController();

  @override
  Widget build(BuildContext context) {
    //TODO intl
    final theme = Theme.of(context);
    final model = context.read<TrainModel>();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                "",
                style: theme.textTheme.displaySmall,
              ),
              const SatelliteInfoWidget(),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Метки",
                  style: theme.textTheme.displaySmall,
                ),
              ),
              const DeviceInfoWidget(),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              Text(
                "Статус",
                style: theme.textTheme.displaySmall,
              ),
              const StatusWidget(size: 46),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Состояние тренировки",
                    style: theme.textTheme.displaySmall,
                  ),
                ),
                Selector<TrainModel, SystemStatus>(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
