import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_logs_controller.dart';
import 'package:inmotion_mobile_test/core/presentation/app_timer_controller.dart';
import 'package:inmotion_mobile_test/core/presentation/app_timer_widget.dart';
import 'package:inmotion_mobile_test/di.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_provider.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/legend_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/logs_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/player_tile.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/status_widget.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class TrainBody extends StatefulWidget {
  const TrainBody({super.key});

  @override
  State<TrainBody> createState() => _TrainBodyState();
}

class _TrainBodyState extends State<TrainBody> {
  final appTimerController = AppTimerController();
  final l = getIt<AppLogsController>();
  final itemController = ItemScrollController();
  var isExpanded = false;

  void scrollToIndex(int index) {
    itemController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 200),
      alignment: 0,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TrainModel>();
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return ScrollablePositionedList.separated(
                  physics: isExpanded ? const NeverScrollableScrollPhysics() : null,
                  itemCount: model.players.length,
                  itemScrollController: itemController,
                  itemBuilder: (context, i) {
                    return PlayerTile(
                      maxHeight: constraints.maxHeight,
                      player: model.players[i],
                      onExpansionWillChange: (_, isExpanded) {
                        if (isExpanded) {
                          scrollToIndex(i);
                        }
                        setState(() {
                          this.isExpanded = !this.isExpanded;
                        });
                      },
                    );
                  },
                  separatorBuilder: (context, i) {
                    return const SizedBox(height: 8);
                  },
                );
              }
            ),
          ),
          const SizedBox(height: 16),
          LogsWidget(controller: l),
        ],
      ),
    );
  }
}
