import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/sheet_button.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';
import 'package:intl/intl.dart';

class TrainTile extends StatelessWidget {
  TrainTile({
    super.key,
    required this.train,
    required this.onButtonPressed,
    required this.onPressed,
  });

  final TrainEntity train;
  final VoidCallback onButtonPressed;
  final VoidCallback onPressed;
  final formatTime = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
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
              onPressed: onButtonPressed,
              child: Center(
                child: Text(
                  "Excel",
                  style: theme.textTheme.titleSmall,
                ),
              ),
            ),
            const SizedBox(width: 10),
            SvgPicture.asset(AppIcons.arrowRight)
          ],
        ),
      ),
    );
  }
}

