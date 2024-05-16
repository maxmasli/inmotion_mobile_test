import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: BorderRadius.circular(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Архив тренировок', style: theme.textTheme.titleMedium),
          TextButton(
            onPressed: () {},
            child: Text(
              'Очистить все',
              style: theme.textTheme.titleSmall,
            ),
          )
        ],
      ),
    );
  }
}
