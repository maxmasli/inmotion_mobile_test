import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/core/presentation/app_icon_button.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_info_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/train_widgets/train_edit_dialog.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TrainEditWidget extends StatelessWidget {
  const TrainEditWidget({super.key});

  String formatCurrentDateTime(DateTime date) {
    DateFormat dayFormat = DateFormat('d MMMM', 'ru');
    String formattedDate = dayFormat.format(date);

    DateFormat weekdayFormat = DateFormat.EEEE('ru');
    String formattedWeekday = weekdayFormat.format(date);

    DateFormat timeFormat = DateFormat('HH:mm');
    String formattedTime = timeFormat.format(date);

    String result = '$formattedDate. $formattedWeekday. $formattedTime';

    return result;
  }

  Future<void> _editTrain(BuildContext context) async {
    final model = context.read<TrainModel>();
    final result = await showDialog<(String name, String description)>(
      context: context,
      builder: (context) => TrainEditDialog(
        initFields: (
          name: model.trainInfo.name,
          description: model.trainInfo.description,
        ),
      ),
    );

    if (result != null) {
      model.setTrainInfo(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final model = context.read<TrainModel>();
    return Selector<TrainModel, TrainInfoEntity>(
      selector: (context, model) => model.trainInfo,
      builder: (context, trainInfo, child) {
        return AppContainer(
          borderRadius: BorderRadius.circular(16),
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(trainInfo.name, style: theme.textTheme.bodySmall),
                  Text(
                    formatCurrentDateTime(model.train!.startTime),
                    style: theme.textTheme.displaySmall,
                  ),
                ],
              ),
              AppIconButton(
                icon: SvgPicture.asset(
                  AppIcons.editThin,
                ),
                onPressed: () async {
                  await _editTrain(context);
                },
              )
            ],
          ),
        );
      },
    );
  }
}
