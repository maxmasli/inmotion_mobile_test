import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/mobile/prepare_train_widgets/player_tile.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/train_widgets/prepare_train_widgets/bluetooth_empty_widget.dart';
import 'package:provider/provider.dart';

class PlayersList extends StatelessWidget {
  const PlayersList({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TrainModel>();
    if (model.players.isEmpty) {
      return const Align(
        alignment: Alignment.topCenter,
        child: BluetoothEmptyWidget(),
      );
    }
    return Selector<TrainModel, List<PlayerEntity>>(
      selector: (context, model) => model.players,
      builder: (context, players, child) {
        return GridView.builder(
          shrinkWrap: true,
          itemCount: players.length,
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 4.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return PlayerTile(
              player: players[index],
            );
          },
        );
      },
    );
  }
}
