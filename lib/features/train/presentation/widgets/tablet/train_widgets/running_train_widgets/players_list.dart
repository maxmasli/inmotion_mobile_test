import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/train_widgets/running_train_widgets/player_tile.dart';
import 'package:provider/provider.dart';

class PlayersList extends StatelessWidget {
  const PlayersList({
    super.key,
    required this.onPlayerSelected,
    required this.selectedPlayer,
  });

  final Function(PlayerEntity?) onPlayerSelected;
  final PlayerEntity? selectedPlayer;

  @override
  Widget build(BuildContext context) {
    final model = context.read<TrainModel>();
    return GridView.builder(
      itemCount: model.selectedPlayers.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 76,
      ),
      itemBuilder: (context, index) {
        return PlayerTile(
          player: model.selectedPlayers[index],
          onTap: () {
            onPlayerSelected(model.selectedPlayers[index]);
          },
          isSelected: selectedPlayer == model.selectedPlayers[index],
        );
      },
    );
  }
}
