import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/split_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/exercise_split/split_tile.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/sheet_button.dart';

class SplitListWidget extends StatefulWidget {
  const SplitListWidget({
    super.key,
    required this.onSplitsChanged,
    required this.initSplits,
    required this.train,
    required this.onDelete,
  });

  final List<SplitEntity> initSplits;
  final Function(List<SplitEntity>) onSplitsChanged;
  final Function() onDelete;
  final TrainEntity train;

  @override
  State<SplitListWidget> createState() => _SplitListWidgetState();
}

class _SplitListWidgetState extends State<SplitListWidget> {
  List<SplitEntity> currentSplits = [];
  List<SplitEntity> selectedSplits = [];

  @override
  void initState() {
    super.initState();
    currentSplits.addAll(widget.initSplits);
    widget.onSplitsChanged(currentSplits);
  }

  void _addSplit() {
    setState(() {
      currentSplits.add(SplitEntity.empty());
    });
    widget.onSplitsChanged(currentSplits);
  }

  void _deleteSplits() {
    setState(() {
      for (final selected in selectedSplits) {
        currentSplits.remove(selected);
      }
      selectedSplits.clear();
    });
    widget.onDelete();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppContainer(
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                toolbarHeight: 50,
                titleSpacing: 0,
                pinned: true,
                backgroundColor: theme.colorScheme.primaryContainer,
                surfaceTintColor: theme.colorScheme.primaryContainer,
                title: Column(
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
                          value: selectedSplits.isEmpty
                              ? false // выбранных нет
                              : selectedSplits.length != currentSplits.length
                                  ? null // выбранные есть, но не все
                                  : true, // все выбранные
                          onChanged: (value) {
                            setState(() {
                              if (selectedSplits.length == currentSplits.length) {
                                // Если все выбранные
                                selectedSplits.clear();
                              } else {
                                selectedSplits.clear();
                                selectedSplits.addAll(currentSplits);
                              }
                            });
                          },
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text("Название фрагмента", style: theme.textTheme.displaySmall),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(width: 100, child: Text("Начало фрагмента", style: theme.textTheme.displaySmall)),
                        const SizedBox(width: 10),
                        SizedBox(width: 100, child: Text('Конец фрагмента', style: theme.textTheme.displaySmall)),
                        const SizedBox(width: 10),
                        SizedBox(width: 100, child: Text('Общее время', style: theme.textTheme.displaySmall)),
                        const SizedBox(width: 40)
                      ],
                    ),
                    const SizedBox(height: 10)
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: currentSplits.length + 1,
                  (context, index) {
                    if (index >= currentSplits.length) {
                      return SheetButton(
                        padding: const EdgeInsets.all(8),
                        onPressed: () {
                          _addSplit();
                        },
                        child: Center(
                          child: Text(
                            "Добавить упражнение",
                            style: theme.textTheme.titleSmall,
                          ),
                        ),
                      );
                    }
                    final split = currentSplits[index];
                    return SplitTile(
                      onCheckboxTap: () {
                        setState(
                          () {
                            if (selectedSplits.contains(split)) {
                              selectedSplits.remove(split);
                            } else {
                              selectedSplits.add(split);
                            }
                          },
                        );
                      },
                      isSelected: selectedSplits.contains(split),
                      split: split,
                      onSplitUpdated: (SplitEntity split) {
                        widget.onSplitsChanged(currentSplits);
                      },
                      trainDuration: widget.train.endTime!
                          .difference(widget.train.startTime),
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
                  onTap: () {
                    _deleteSplits();
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
