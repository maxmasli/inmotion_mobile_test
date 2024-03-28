import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/running_train_widgets/legend_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/running_train_widgets/player_tile.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/train_history_sheet.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class RunningTrainWidget extends StatefulWidget {
  const RunningTrainWidget({super.key});

  @override
  State<RunningTrainWidget> createState() => _RunningTrainWidgetState();
}

class _RunningTrainWidgetState extends State<RunningTrainWidget> {
  var isExpanded = false;
  final itemController = ItemScrollController();

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
    final model = context.read<TrainModel>();
    return Expanded(
      child: Column(
        children: [
          const LegendWidget(),
          const SizedBox(height: 16),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return ScrollablePositionedList.separated(
                  padding: EdgeInsets.zero,
                  physics:
                      isExpanded ? const NeverScrollableScrollPhysics() : null,
                  itemCount: model.players.length,
                  itemScrollController: itemController,
                  itemBuilder: (context, i) {
                    return PlayerTile(
                      maxHeight: constraints.maxHeight,
                      player: model.players[i],
                      onExpansion: (_, isExpanded) {
                        if (isExpanded) {
                          scrollToIndex(i);
                        }
                        setState(
                          () {
                            this.isExpanded = !this.isExpanded;
                          },
                        );
                      },
                    );
                  },
                  separatorBuilder: (context, i) {
                    return const SizedBox(height: 8);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
