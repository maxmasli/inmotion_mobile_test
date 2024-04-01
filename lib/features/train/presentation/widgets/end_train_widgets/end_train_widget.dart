import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/core/presentation/train_text_field.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/end_train_widgets/loading_button.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/train_history_sheet.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class EndTrainWidget extends StatelessWidget {
  const EndTrainWidget({super.key});

  Future<void> createAndShareFile(TrainModel model, TrainEntity train) async {
    final path = await model.createExcel(train);
    final xfile = XFile(path);
    await Share.shareXFiles([xfile]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final model = context.read<TrainModel>();
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppContainer(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              borderRadius: BorderRadius.circular(16),
              child: Selector<TrainModel, double>(
                selector: (context, model) => model.loadingPercent,
                builder: (context, percent, child) {
                  return Column(
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
                        percent: percent,
                        onPressed: () async {
                          await createAndShareFile(model, model.train!);
                        },
                      ),
                      if (percent >= 100) ...[
                        const SizedBox(height: 10),
                        TrainTextField(
                          controller: TextEditingController(),
                          hint: 'Введите название тренировки',
                          onChanged: (value) async {
                            await model.updateCurrentTrainName(value);
                          },
                        ),
                        const SizedBox(height: 10),
                        AppContainer(
                          borderRadius: BorderRadius.circular(8),
                          padding: const EdgeInsets.all(10),
                          elevation: 0,
                          onTap: () {
                            model.prepareRecording();
                          },
                          color: theme.colorScheme.secondaryContainer,
                          child: Center(
                            child: Text(
                              "Вернуться",
                              style: theme.textTheme.labelSmall,
                            ),
                          ),
                        ),
                      ]
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
