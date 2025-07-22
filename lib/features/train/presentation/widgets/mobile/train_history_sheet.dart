import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/core/utils/utils.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/mobile/train_edit_tile.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/mobile/train_tile.dart';
import 'package:provider/provider.dart';

const bottomSheetMinHeight = 0.15;

class TrainHistorySheet extends StatefulWidget {
  const TrainHistorySheet({
    super.key,
  });

  @override
  State<TrainHistorySheet> createState() => _TrainHistorySheetState();
}

class _TrainHistorySheetState extends State<TrainHistorySheet> {
  var _editMode = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DraggableScrollableSheet(
      initialChildSize: bottomSheetMinHeight,
      minChildSize: bottomSheetMinHeight,
      maxChildSize: 0.86,
      snap: true,
      expand: true,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            color: theme.colorScheme.primaryContainer,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: _editMode
              ? _TrainEditSliverList(
                  controller: scrollController,
                  onCancel: () {
                    setState(
                      () {
                        _editMode = false;
                      },
                    );
                  },
                )
              : _TrainSliverList(
                  controller: scrollController,
                  onEditPressed: () {
                    setState(
                      () {
                        _editMode = true;
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}

class _TrainEditSliverList extends StatefulWidget {
  const _TrainEditSliverList({
    required this.controller,
    required this.onCancel,
  });

  final ScrollController controller;
  final VoidCallback onCancel;

  @override
  State<_TrainEditSliverList> createState() => _TrainEditSliverListState();
}

class _TrainEditSliverListState extends State<_TrainEditSliverList> {
  final selectedTrains = <TrainEntity>[];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final model = context.read<TrainModel>();
    return Selector<TrainModel, List<TrainEntity>>(
      selector: (context, model) => model.trains,
      shouldRebuild: (prev, curr) => prev != curr,
      builder: (context, trains, child) {
        log(trains.toString());
        return CustomScrollView(
          controller: widget.controller,
          slivers: [
            SliverAppBar(
              toolbarHeight: 30,
              titleSpacing: 0,
              pinned: true,
              backgroundColor: theme.colorScheme.primaryContainer,
              surfaceTintColor: theme.colorScheme.primaryContainer,
              title: Row(
                children: [
                  Text(
                    "Архив тренировок",
                    style: theme.textTheme.titleMedium,
                  )
                ],
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(80),
                child: Column(
                  children: [
                    Row(
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
                              : selectedTrains.length != trains.length
                                  ? null // выбранные есть, но не все
                                  : true, // все выбранные
                          onChanged: (value) {
                            setState(() {
                              if (selectedTrains.length == trains.length) {
                                // Если все выбранные
                                selectedTrains.clear();
                              } else {
                                selectedTrains.clear();
                                selectedTrains.addAll(trains);
                              }
                            });
                          },
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppContainer(
                            onTap: () async {
                              await model.deleteTrains(selectedTrains);
                              selectedTrains.clear();
                            },
                            padding: const EdgeInsets.all(4),
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
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: AppContainer(
                            onTap: widget.onCancel,
                            padding: const EdgeInsets.all(4),
                            height: 30,
                            borderRadius: BorderRadius.circular(8),
                            color: theme.colorScheme.secondaryContainer,
                            elevation: 0,
                            child: Center(
                              child: Text(
                                "Отменить",
                                style: theme.textTheme.labelSmall,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: trains.length,
                (context, index) {
                  final train = trains.reversed.toList()[index];
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
        );
      },
    );
  }
}

class _TrainSliverList extends StatelessWidget {
  const _TrainSliverList({
    required this.controller,
    required this.onEditPressed,
  });

  final ScrollController controller;
  final VoidCallback onEditPressed;

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
        return CustomScrollView(
          controller: controller,
          slivers: [
            SliverAppBar(
              toolbarHeight: 30,
              titleSpacing: 0,
              pinned: true,
              backgroundColor: theme.colorScheme.primaryContainer,
              surfaceTintColor: theme.colorScheme.primaryContainer,
              title: Row(
                children: [
                  Text(
                    "Архив тренировок",
                    style: theme.textTheme.titleMedium,
                  )
                ],
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: trains.length,
                (context, index) {
                  return TrainTile(
                    train: trains.reversed.toList()[index],
                    onPressed: () async {
                      await createAndShareFile(
                        model,
                        trains.reversed.toList()[index],
                      );
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
