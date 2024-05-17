import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/player_info/player_map_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/player_info/player_stats_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/player_info/train_description_widget.dart';

class PlayerInfoWidget extends StatelessWidget {
  const PlayerInfoWidget({
    super.key,
    required this.train,
    required this.onBackPressed,
    required this.player,
  });

  final TrainEntity train;
  final PlayerEntity player;
  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                child: PlayerStatsWidget(
                  player: player,
                  train: train,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: PlayerMapWidget(
                  player: player,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
