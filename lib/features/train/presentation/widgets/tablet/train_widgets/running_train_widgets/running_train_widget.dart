import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/train_widgets/running_train_widgets/heart_rate_zones_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/train_widgets/running_train_widgets/players_list.dart';

class RunningTrainWidget extends StatefulWidget {
  const RunningTrainWidget({super.key});

  @override
  State<RunningTrainWidget> createState() => _RunningTrainWidgetState();
}

class _RunningTrainWidgetState extends State<RunningTrainWidget> {
  PlayerEntity? _selectedPlayer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(
              flex: 2,
              child: HeartRateZonesWidget(),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Center(child: Text("train edit")),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: PlayersList(
                  selectedPlayer: _selectedPlayer,
                  onPlayerSelected: (player) {
                    setState(() {
                      if (player == _selectedPlayer) {
                        _selectedPlayer = null;
                      } else {
                        _selectedPlayer = player;
                      }
                    });
                  }
                ),
              ),
              if (_selectedPlayer != null)
                const Expanded(
                  child: Text("info"),
                )
            ],
          ),
        )
      ],
    );
  }
}
