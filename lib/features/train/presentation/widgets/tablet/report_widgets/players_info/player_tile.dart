import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/sheet_button.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';

class PlayerTile extends StatelessWidget {
  const PlayerTile({
    super.key,
    required this.onPressed,
    required this.player,
    required this.onButtonPressed,
  });

  final VoidCallback onPressed;
  final PlayerEntity player;
  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) { // TODO реализовать редактирование игроков
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              player.number.toString(),
              style: theme.textTheme.displayMedium,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                player.name,
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
