import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/colors.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';

class LegendWidget extends StatelessWidget {
  const LegendWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppContainer(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      borderRadius: BorderRadius.circular(16),
      child: DefaultTextStyle(
        style: theme.textTheme.displaySmall!,
        child: const Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LegendItem(
                  color: Colors.transparent,
                  text: 'Зоны ЧСС',
                  hasIndicator: false,
                ),
                LegendItem(color: AppColors.red, text: 'Макс.'),
                LegendItem(color: AppColors.orange, text: 'Анаэроб.'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LegendItem(color: AppColors.green, text: 'Аэроб.'),
                LegendItem(color: AppColors.blue, text: 'Легкая'),
                LegendItem(color: AppColors.gray186, text: 'Умеренная'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  const LegendItem({
    super.key,
    required this.color,
    required this.text,
    this.maxWidth = 100,
    this.minWidth = 100,
    this.hasIndicator = true,
  });

  final Color color;
  final String text;
  final double maxWidth;
  final double minWidth;
  final bool hasIndicator;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        minWidth: minWidth,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (hasIndicator) ...[
            SizedBox(
              width: 12,
              height: 12,
              child: ClipOval(
                child: ColoredBox(
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
