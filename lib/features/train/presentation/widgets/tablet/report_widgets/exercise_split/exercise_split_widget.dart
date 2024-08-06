import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/split_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/exercise_split/split_list_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/players_info/train_description_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/sheet_button.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/train_calendar.dart';

class ExerciseSplitWidget extends StatefulWidget {
  const ExerciseSplitWidget({
    super.key,
    required this.train,
    required this.onBackPressed,
    required this.onRangeChanged,
    required this.range,
    required this.onCancel,
    required this.onSplitsUpdated,
  });

  final TrainEntity train;
  final Function() onBackPressed;
  final Function(List<DateTime?>) onRangeChanged;
  final Function() onCancel;
  final Function(List<SplitEntity>) onSplitsUpdated;
  final List<DateTime?> range;

  @override
  State<ExerciseSplitWidget> createState() => _ExerciseSplitWidgetState();
}

class _ExerciseSplitWidgetState extends State<ExerciseSplitWidget> {
  List<SplitEntity> splits = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TrainDescriptionWidget(
          train: widget.train,
          onBackPressed: widget.onBackPressed,
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: TrainCalendar(
                    onDateRangeSelected: (List<DateTime?> range) {
                      widget.onRangeChanged(range);
                    },
                    initRange: widget.range,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    AppContainer(
                      padding: const EdgeInsets.all(16),
                      borderRadius: BorderRadius.circular(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: SheetButton(
                              padding: const EdgeInsets.all(8),
                              onPressed: widget.onCancel,
                              child: Center(
                                child: Text(
                                  "Отменить",
                                  style: theme.textTheme.titleSmall,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SheetButton(
                              padding: const EdgeInsets.all(8),
                              onPressed: splits
                                      .where((e) => !e.correctFragments(widget.train.endTime!.difference(widget.train.startTime)))
                                      .isEmpty
                                  ? () {
                                      widget.onSplitsUpdated(splits);
                                      widget.onCancel();
                                    }
                                  : null,
                              child: Center(
                                child: Text(
                                  "Сохранить деление",
                                  style: theme.textTheme.titleSmall,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: SplitListWidget(
                        onSplitsChanged: (List<SplitEntity> splits) {
                          this.splits = splits;
                          WidgetsBinding.instance.addPostFrameCallback((d) {
                            setState(() {});
                          });
                        },
                        initSplits: widget.train.exerciseSplits,
                        train: widget.train,
                        onDelete: () {
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
