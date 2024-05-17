import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/players_info/player_edit_tile.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/players_info/player_tile.dart';
import 'package:provider/provider.dart';

class PlayerList extends StatefulWidget {
  const PlayerList({
    super.key,
    required this.train,
    required this.onPlayerSelected,
  });

  final TrainEntity train;
  final Function(PlayerEntity) onPlayerSelected;

  @override
  State<PlayerList> createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  var _editMode = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppContainer(
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(12),
      child: _editMode
          ? _PlayerEditList(
        onCancel: () {
          setState(() {
            _editMode = false;
          });
        }, train: widget.train,
      )
          : _PlayerList(
        train: widget.train,
        onEditPressed: () {
          setState(() {
            _editMode = true;
          });
        },
        onPlayerSelected: widget.onPlayerSelected,
      ),
    );
  }
}

class _PlayerEditList extends StatefulWidget {
  const _PlayerEditList({
    required this.onCancel,
    required this.train,
  });

  final VoidCallback onCancel;
  final TrainEntity train;

  @override
  State<_PlayerEditList> createState() => _PlayerEditListState();
}

class _PlayerEditListState extends State<_PlayerEditList> {
  final selectedPlayers = <PlayerEntity>[];
  late ValueNotifier<List<PlayerEntity>> playersNotifier;

  @override
  void initState() {
    super.initState();
    playersNotifier = ValueNotifier(widget.train.players);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final model = context.read<TrainModel>();
    return ValueListenableBuilder(
      valueListenable: playersNotifier,
      builder: (BuildContext context, value, Widget? child) {
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
                        value: selectedPlayers.isEmpty
                            ? false // выбранных нет
                            : selectedPlayers.length !=
                            widget.train.players.length
                            ? null // выбранные есть, но не все
                            : true, // все выбранные
                        onChanged: (value) {
                          setState(() {
                            if (selectedPlayers.length ==
                                widget.train.players.length) {
                              // Если все выбранные
                              selectedPlayers.clear();
                            } else {
                              selectedPlayers.clear();
                              selectedPlayers.addAll(widget.train.players);
                            }
                          });
                        },
                      )
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: widget.train.players.length,
                        (context, index) {
                      final player = widget.train.players[index];
                      return PlayerEditTile(
                        train: widget.train,
                        player: player,
                        onCheckboxTap: () {
                          setState(() {
                            if (selectedPlayers.contains(player)) {
                              selectedPlayers.remove(player);
                            } else {
                              selectedPlayers.add(player);
                            }
                          });
                        },
                        isSelected: selectedPlayers.contains(player),
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
                      await model.deletePlayersFromTrain(
                        widget.train,
                        selectedPlayers,
                      );
                      playersNotifier.value = widget.train.players;
                      selectedPlayers.clear();
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

class _PlayerList extends StatelessWidget {
  const _PlayerList({
    required this.onEditPressed,
    required this.train,
    required this.onPlayerSelected,
  });

  final TrainEntity train;
  final VoidCallback onEditPressed;
  final Function(PlayerEntity) onPlayerSelected;

  Future<void> createAndShareFile(TrainModel model, TrainEntity train,
      PlayerEntity player) async {
    //final path = await model.createExcel(train);
    //await shareFile(path);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final model = context.read<TrainModel>();
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
                "Выберите игрока для просмотра его статистики",
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
            childCount: train.players.length,
                (context, index) {
              final player = train.players[index];
              return PlayerTile(
                player: player,
                onButtonPressed: () async {
                  await createAndShareFile(model, train, player);
                },
                onPressed: () {
                  onPlayerSelected(player);
                },
              );
            },
          ),
        )
      ],
    );
  }
}
