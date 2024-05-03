import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/colors.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';

class HeartRateZonesWidget extends StatelessWidget {
  const HeartRateZonesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppContainer(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Зоны ЧСС", // TODO intl
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              _ZoneLabel(
                color: AppColors.red,
                text: 'Максимальная интенсивность',
              ),
              SizedBox(width: 4),
              _ZoneLabel(
                color: AppColors.yellow,
                text: 'Анаэробный режим',
              ),
              SizedBox(width: 4),
              _ZoneLabel(
                color: AppColors.green,
                text: 'Аэробный режим',
              ),
              SizedBox(width: 4),
              _ZoneLabel(
                color: AppColors.blue,
                text: 'Легкая нагрузка',
              ),
              SizedBox(width: 4),
              _ZoneLabel(
                color: AppColors.gray186,
                text: 'Умеренная активность',
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _ZoneLabel extends StatelessWidget {
  const _ZoneLabel({super.key, required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
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
        const SizedBox(width: 2),
        Text(
          text,
          style: theme.textTheme.headlineSmall?.copyWith(fontSize: 10),
        )
      ],
    );
  }
}
