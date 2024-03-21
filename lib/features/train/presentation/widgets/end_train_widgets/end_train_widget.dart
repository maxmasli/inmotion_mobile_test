import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/end_train_widgets/loading_button.dart';

class EndTrainWidget extends StatelessWidget {
  const EndTrainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppContainer(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Тренировка завершена", style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          Text(
            "Отчет о тренировке формируется, это может занять некоторое время. Пожалуйста не выключайте устройство и не закрывайте окно приложения",
            style: theme.textTheme.displaySmall,
          ),
          const SizedBox(height: 10),
          LoadingButton(
            padding: const EdgeInsets.all(8),
            progressColor: theme.colorScheme.secondaryContainer,
            backgroundColor:
                theme.colorScheme.secondaryContainer.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            loadingWidget: Text(
              "Формирование отчета",
              style: theme.textTheme.labelSmall,
            ),
            loadedWidget: Text(
              "Скачать отчет в Excel",
              style: theme.textTheme.labelSmall,
            ),
            percent: 100,
            onPressed: () {
              log("asd");
            },
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
