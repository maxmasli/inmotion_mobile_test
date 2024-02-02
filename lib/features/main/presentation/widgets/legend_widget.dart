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
          _LegendItem(color: AppColors.red, text: 'Максимальная интенсивность'),
          _LegendItem(color: AppColors.orange, text: 'Анаэробный режим'),
          _LegendItem(color: AppColors.green, text: 'Аэробный режим'),
          _LegendItem(color: AppColors.blue, text: 'Легкая нагрузка'),
          _LegendItem(color: AppColors.gray186, text: 'Умеренная активность'),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.text,
  });

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 100,
        minWidth: 100,
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
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              text,
              style: theme.textTheme.displaySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
