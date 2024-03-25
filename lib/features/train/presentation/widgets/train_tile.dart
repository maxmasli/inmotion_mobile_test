import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/sheet_button.dart';
import 'package:intl/intl.dart';

class TrainTile extends StatelessWidget {
  TrainTile({
    super.key,
    required this.train,
  });

  final TrainEntity train;
  final formatTime = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            child: Text(
              train.trainName,
              style: theme.textTheme.displayMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SheetButton(
            padding: const EdgeInsets.all(4),
            child: Center(
              child: Text(
                "Excel",
                style: theme.textTheme.titleSmall,
              ),
            ),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
