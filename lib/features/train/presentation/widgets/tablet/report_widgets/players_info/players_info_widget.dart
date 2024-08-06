import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/players_info/player_list.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/players_info/train_description_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/train_calendar.dart';

class PlayersInfoWidget extends StatelessWidget {
  const PlayersInfoWidget({
    super.key,
    required this.train,
    required this.onRangeChanged,
    required this.onBackPressed,
    required this.onPlayerSelected,
    required this.range,
    required this.onSplitSelect,
  });

  final List<DateTime?> range;
  final TrainEntity train;
  final Function(List<DateTime?>) onRangeChanged;
  final VoidCallback onBackPressed;
  final Function(PlayerEntity) onPlayerSelected;
  final Function() onSplitSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TrainDescriptionWidget(
          train: train,
          onBackPressed: onBackPressed,
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: TrainCalendar(
                    onDateRangeSelected: (List<DateTime?> range) {
                      onRangeChanged(range);
                    },
                    initRange: range,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: PlayerList(
                  onSplitSelect: onSplitSelect,
                  train: train,
                  onPlayerSelected: onPlayerSelected,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
