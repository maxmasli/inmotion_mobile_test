import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/train_text_field.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TrainEditTile extends StatelessWidget {
  TrainEditTile({
    super.key,
    required this.train,
    required this.onCheckboxTap,
    required this.isSelected,
  });

  final TrainEntity train;
  final VoidCallback onCheckboxTap;
  final bool isSelected;
  final formatTime = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final model = context.read<TrainModel>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            formatTime.format(train.startTime),
            style: theme.textTheme.displayMedium,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TrainTextField(
              controller: TextEditingController(text: train.trainName),
              hint: 'Введите название',
              onChanged: (value) {
                model.updateTrainName(train, value);
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
