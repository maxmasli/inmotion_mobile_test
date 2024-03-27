import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/train_tile.dart';
import 'package:provider/provider.dart';

const bottomSheetMinHeight = 0.15;
final sheetKey = GlobalKey();

class TrainHistorySheet extends StatelessWidget {
  const TrainHistorySheet({
    super.key,
  });

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
          child: _TrainSliverList(
            controller: scrollController,
          ),
        );
      },
    );
  }
}

class _TrainSliverList extends StatelessWidget {
  const _TrainSliverList({
    required this.controller,
  });

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                      onPressed: () {},
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
                  return TrainTile(train: trains.reversed.toList()[index]);
                },
              ),
            )
          ],
        );
      },
    );
  }
}
