import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inmotion_mobile_test/core/presentation/train_text_field.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:provider/provider.dart';

class PlayerEditTile extends StatelessWidget {
  const PlayerEditTile({
    super.key,
    required this.player,
    required this.onCheckboxTap,
    required this.isSelected,
    required this.train,
  });

  final PlayerEntity player;
  final TrainEntity train;
  final VoidCallback onCheckboxTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final model = context.read<TrainModel>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            child: TrainTextField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputType: TextInputType.number,
              controller: TextEditingController(text: player.number.toString()),
              hint: '№',
              onChanged: (value) async {
                await model.updatePlayerNumber(train, player, value);
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TrainTextField(
              controller: TextEditingController(text: player.name),
              hint: 'Введите имя',
              onChanged: (value) async {
                await model.updatePlayerName(train, player, value);
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
