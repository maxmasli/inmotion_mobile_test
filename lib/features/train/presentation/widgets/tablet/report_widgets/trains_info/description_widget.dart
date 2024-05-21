import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/core/presentation/app_question_dialog.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:provider/provider.dart';

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({super.key});

  Future<void> _clearAll(BuildContext context) async {
    final model = context.read<TrainModel>();
    final result = await showDialog<bool>(
        context: context,
        builder: (context) => const AppQuestionDialog(
              title: 'Очистить все данные',
              content:
                  'ВНИМАНИЕ! Данные не подлежат восстановлению, если не были сохранены на другом устройстве. Полная очистка истории тренировок приведет также к полному удалению всех данных, включая отчеты тренировок и данные в календаре',
              yesText: 'Очистить',
              noText: 'Отмена',
            ));
    if (result ?? false) {
      await model.deleteTrains(model.trains);
    }
  }

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
            onPressed: () async {
              await _clearAll(context);
            },
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
