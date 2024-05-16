import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/train_text_field.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';

class PlayerEditTile extends StatelessWidget {
  const PlayerEditTile({
    super.key,
    required this.player,
    required this.onCheckboxTap,
    required this.isSelected,
  });

  final PlayerEntity player;
  final VoidCallback onCheckboxTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //final model = context.read<TrainModel>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            child: TrainTextField(
              controller: TextEditingController(text: player.number.toString()),
              hint: '№',
              onChanged: (value) async {
                //await model.updateTrainName(player, value);
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TrainTextField(
              controller: TextEditingController(text: player.name),
              hint: 'Введите имя',
              onChanged: (value) async {
                //await model.updateTrainName(player, value);
              },
            ),
          ),
          Checkbox(
            value: isSelected,
            onChanged: (value) {
              onCheckboxTap();
            },
          )
        ],
      ),
    );
  }
}
