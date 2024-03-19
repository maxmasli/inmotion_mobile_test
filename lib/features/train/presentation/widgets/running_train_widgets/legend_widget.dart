import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/colors.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';

class LegendWidget extends StatelessWidget {
  const LegendWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      borderRadius: BorderRadius.circular(16),
      child: const Wrap(
        spacing: 12,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          LegendItem(color: AppColors.red, text: 'Максимальная интенсивность'),
          LegendItem(color: AppColors.orange, text: 'Анаэробный режим'),
          LegendItem(color: AppColors.green, text: 'Аэробный режим'),
          LegendItem(color: AppColors.blue, text: 'Легкая нагрузка'),
          LegendItem(color: AppColors.gray186, text: 'Умеренная активность'),
        ],
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
  });

  final Color color;
  final String text;
  final double maxWidth;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        minWidth: minWidth,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
          Flexible(
            child: Text(
              text,
              style: theme.textTheme.displaySmall?.copyWith(fontSize: 10),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
