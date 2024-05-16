import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/core/utils/utils.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';
import 'package:intl/intl.dart';

class TrainDescriptionWidget extends StatelessWidget {
  const TrainDescriptionWidget({
    super.key,
    required this.train,
    required this.onBackPressed,
  });

  final TrainEntity train;
  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: BorderRadius.circular(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('d MMMM HH:mm', 'ru').format(train.startTime),
                style: theme.textTheme.headlineMedium,
              ),
              Text(
                "Тренировка 001",
                style: theme.textTheme.bodyMedium,
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Время тренировки: ",
                      style: theme.textTheme.bodyMedium,
                    ),
                    TextSpan(
                      text: formatDuration(
                          train.endTime!.difference(train.startTime)),
                      style: theme.textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Описание тренировки: ',
                      style: theme.textTheme.headlineSmall,
                    ),
                    TextSpan(
                      text:
                          'Lorem ipsum dolor sit amet consectetur. Ac diam odio quam facilisis nec \nmagna. Id ipsum eu at sit sodales nisi vulputate. Viverra eu risus molestie nibhat sit sodales nisi',
                      style: theme.textTheme.displaySmall,
                    ),
                  ],
                ),
              )
            ],
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 160,
            ),
            child: TextButton(
              onPressed: onBackPressed,
              child: Row(
                children: [
                  SvgPicture.asset(AppIcons.arrowLeft),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      'Назад к списку тренировок',
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
