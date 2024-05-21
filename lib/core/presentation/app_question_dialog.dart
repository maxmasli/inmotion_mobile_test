import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_button.dart';

class AppQuestionDialog extends StatelessWidget {
  const AppQuestionDialog({
    super.key,
    required this.title,
    required this.content,
    required this.yesText,
    required this.noText,
  });

  final String title;
  final String content;
  final String yesText;
  final String noText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(title, style: theme.textTheme.titleMedium),
      content: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 400, maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(content, style: theme.textTheme.displayMedium),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    padding: const EdgeInsets.all(8),
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Center(
                      child: Text(
                        yesText,
                        style: theme.textTheme.labelSmall,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    padding: const EdgeInsets.all(8),
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Center(
                      child: Text(
                        noText,
                        style: theme.textTheme.labelSmall,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
