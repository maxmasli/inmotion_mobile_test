import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/core/presentation/app_question_dialog.dart';
import 'package:inmotion_mobile_test/core/utils/utils.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/trains_info/train_edit_tile.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/trains_info/train_tile.dart';
import 'package:provider/provider.dart';

class TrainList extends StatefulWidget {
  const TrainList({
    super.key,
    required this.range,
    required this.onTrainSelect,
  });

  final List<DateTime?> range;
  final Function(TrainEntity) onTrainSelect;

  @override
  State<TrainList> createState() => _TrainListState();
}

class _TrainListState extends State<TrainList> {
  var _editMode = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppContainer(
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(12),
      child: _editMode
          ? _TrainEditList(
              onCancel: () {
                setState(() {
                  _editMode = false;
                });
              },
              range: widget.range,
            )
          : _TrainList(
              onEditPressed: () {
                setState(() {
                  _editMode = true;
                });
              },
              range: widget.range,
              onTrainSelect: widget.onTrainSelect,
            ),
    );
  }
}

class _TrainEditList extends StatefulWidget {
  const _TrainEditList({required this.onCancel, required this.range});

  final VoidCallback onCancel;
  final List<DateTime?> range;

  @override
  State<_TrainEditList> createState() => _TrainEditListState();
}

class _TrainEditListState extends State<_TrainEditList> {
  final selectedTrains = <TrainEntity>[];

  Future<void> _deleteTrains() async {
    final model = context.read<TrainModel>();
    final result = await showDialog<bool>(
        context: context,
        builder: (context) => const AppQuestionDialog(
              title: "Удалить  тренировку?",
              content:
                  "Удаление тренировки приведет также к полному удалению ее данных, включая отчет тренировки и данные в календаре",
              yesText: 'Удалить',
              noText: 'Отмена',
            ));
    if (result ?? false) {
      await model.deleteTrains(selectedTrains);
      selectedTrains.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final model = context.read<TrainModel>();
    return Selector<TrainModel, List<TrainEntity>>(
      selector: (context, model) => model.trains,
      shouldRebuild: (prev, curr) => prev != curr,
      builder: (context, trains, child) {
        var rangesTrains = <TrainEntity>[];
        if (widget.range.length == 1) {
          rangesTrains = trains
              .where((train) => train.startTime.isSameDay(widget.range[0]!))
              .toList();
        } else if (widget.range.length == 2) {
          rangesTrains = trains
              .where((train) =>
                  train.startTime.isAfter(widget.range[0]!) &&
                  train.startTime.isBefore(widget.range[1]!))
              .toList();
        } else if (widget.range.isEmpty) {
          rangesTrains = trains;
        }
        return Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  toolbarHeight: 30,
                  titleSpacing: 0,
                  pinned: true,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  surfaceTintColor: theme.colorScheme.primaryContainer,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Выделить все",
                        style: theme.textTheme.titleSmall,
                      ),
                      Checkbox(
                        tristate: true,
                        value: selectedTrains.isEmpty
                            ? false // выбранных нет
                            : selectedTrains.length != rangesTrains.length
                                ? null // выбранные есть, но не все
                                : true, // все выбранные
                        onChanged: (value) {
                          setState(() {
                            if (selectedTrains.length == rangesTrains.length) {
                              // Если все выбранные
                              selectedTrains.clear();
                            } else {
                              selectedTrains.clear();
                              selectedTrains.addAll(rangesTrains);
                            }
                          });
                        },
                      )
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: rangesTrains.length,
                    (context, index) {
                      final train = rangesTrains.reversed.toList()[index];
                      return TrainEditTile(
                        train: train,
                        isSelected: selectedTrains.contains(train),
                        onCheckboxTap: () {
                          setState(() {
                            if (selectedTrains.contains(train)) {
                              selectedTrains.remove(train);
                            } else {
                              selectedTrains.add(train);
                            }
                          });
                        },
                      );
                    },
                  ),
                )
              ],
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: Row(
                children: [
                  AppContainer(
                    width: 100,
                    onTap: () async {
                      await _deleteTrains();
                    },
                    padding: const EdgeInsets.all(8),
                    borderRadius: BorderRadius.circular(8),
                    color: theme.colorScheme.secondaryContainer,
                    elevation: 0,
                    child: Center(
                      child: Text(
                        "Удалить",
                        style: theme.textTheme.labelSmall,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  AppContainer(
                    width: 100,
                    onTap: widget.onCancel,
                    padding: const EdgeInsets.all(8),
                    borderRadius: BorderRadius.circular(8),
                    color: theme.colorScheme.secondaryContainer,
                    elevation: 0,
                    child: Center(
                      child: Text(
                        "Отменить",
                        style: theme.textTheme.labelSmall,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

class _TrainList extends StatelessWidget {
  const _TrainList({
    required this.onEditPressed,
    required this.range,
    required this.onTrainSelect,
  });

  final VoidCallback onEditPressed;
  final Function(TrainEntity) onTrainSelect;
  final List<DateTime?> range;

  Future<void> createAndShareFile(TrainModel model, TrainEntity train) async {
    final path = await model.createExcel(train);
    await shareFile(path);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final model = context.read<TrainModel>();
    return Selector<TrainModel, List<TrainEntity>>(
      selector: (context, model) => model.trains,
      shouldRebuild: (prev, curr) => prev != curr,
      builder: (context, trains, child) {
        var rangesTrains = <TrainEntity>[];
        if (range.length == 1) {
          rangesTrains = trains
              .where((train) => train.startTime.isSameDay(range[0]!))
              .toList();
        } else if (range.length == 2) {
          rangesTrains = trains
              .where((train) =>
                  train.startTime.isAfter(range[0]!) &&
                  train.startTime
                      .isBefore(range[1]!.add(const Duration(days: 1))))
              .toList();
        } else if (range.isEmpty) {
          rangesTrains = trains;
        }
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: 30,
              titleSpacing: 0,
              pinned: true,
              backgroundColor: theme.colorScheme.primaryContainer,
              surfaceTintColor: theme.colorScheme.primaryContainer,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Выберите тренировку для просмотра данных игроков",
                    style: theme.textTheme.displaySmall,
                  ),
                  TextButton(
                    onPressed: onEditPressed,
                    child: Text(
                      "Редактировать",
                      style: theme.textTheme.titleSmall,
                    ),
                  )
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: rangesTrains.length,
                (context, index) {
                  final train = rangesTrains.reversed.toList()[index];
                  return TrainTile(
                    train: train,
                    onButtonPressed: () async {
                      await createAndShareFile(
                        model,
                        trains.reversed.toList()[index],
                      );
                    },
                    onPressed: () {
                      onTrainSelect(train);
                    },
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }
}
