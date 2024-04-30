import 'package:flutter/material.dart';

class InfoText extends StatelessWidget {
  const InfoText({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO intl
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "inmotion-sports.tech",
            style: theme.textTheme.displaySmall,
          ),
          Text(
            "info@inmotion-sports.tech",
            style: theme.textTheme.displaySmall,
          ),
          const SizedBox(height: 4),
          Text(
            "Это приложение является объектом авторского права и принадлежит ООО \"Инмоушн\".",
            style: theme.textTheme.displaySmall?.copyWith(fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            "Подробнее",
            style: theme.textTheme.displaySmall,
          ),
        ],
      ),
    );
  }
}
