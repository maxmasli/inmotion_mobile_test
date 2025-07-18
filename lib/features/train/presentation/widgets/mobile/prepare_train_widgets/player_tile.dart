import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inmotion_mobile_test/core/colors.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/core/presentation/app_icon_button.dart';
import 'package:inmotion_mobile_test/core/presentation/app_question_dialog.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/sensor_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/mobile/prepare_train_widgets/player_edit_dialog.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';
import 'package:provider/provider.dart';

class PlayerTile extends StatelessWidget {
  const PlayerTile({super.key, required this.player});

  final PlayerEntity player;

  Future<void> openEditDialog(BuildContext context, TrainModel model) async {
    final data = await showDialog<(String, String, String)>(
      context: context,
      barrierColor: Theme
          .of(context)
          .colorScheme
          .secondaryContainer
          .withOpacity(0.5),
      builder: (context) {
        return PlayerEditDialog(
          initFields: (
          name: player.name,
          number: player.number.toString(),
          deviceNumber: player.sensor!.number.toString(),
          deviceName: player.sensor!.device.remoteId.str,
          ),
        );
      },
    );
    if (data != null) {
      await model.updateSensorPlayer(player, data.$1, data.$2, data.$3);
    }
  }

  Future<void> openDeleteDialog(BuildContext context, TrainModel model,
      PlayerEntity player,) async {
    final data = await showDialog<bool>(context: context, builder: (context) {
      return AppQuestionDialog(title: 'Удалить игрока ${player.name}?',
          content: 'Удаление игрока приведет к удалению данных о нем',
          yesText: "Да",
          noText: "Нет");
    });

    if (data != null && data) {
      await model.deleteSensorPlayer(player);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final model = context.read<TrainModel>();
    final selectedPlayers = context.select<TrainModel, List<PlayerEntity>>(
            (model) => model.selectedPlayers);
    return ChangeNotifierProvider<PlayerEntity>.value(
        value: player,
        child: Consumer<PlayerEntity>(
          builder: (context, player, child) {
            return GestureDetector(
              onLongPress: () async {
                await openDeleteDialog(context, model, player);
              },
              child: AppContainer(
                padding: const EdgeInsets.only(left: 4, right: 8),
                borderRadius: BorderRadius.circular(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: selectedPlayers.contains(player),
                        onChanged: (val) {
                          model.toggleSelectedPlayers(player);
                        },
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${player.number} ${player.name}",
                            style: theme.textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            player.sensor!.device.advName,
                            style: theme.textTheme.displaySmall,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                    _HrInfoWidget(sensor: player.sensor!),
                    const SizedBox(width: 8),
                    AppIconButton(
                      icon: SvgPicture.asset(AppIcons.edit),
                      onPressed: () async =>
                      await openEditDialog(context, model),
                      size: 26,
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(AppIcons.battery100, height: 26),
                    const SizedBox(width: 8),
                    _IndicatorWidget(sensor: player.sensor!),
                  ],
                ),
              ),
            );
          },
        ));
  }
}

class _HrInfoWidget extends StatelessWidget {
  const _HrInfoWidget({required this.sensor});

  final SensorEntity sensor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider.value(
      value: sensor,
      child: Consumer<SensorEntity>(
        builder: (context, sensor, child) {
          return SvgPicture.asset(
            AppIcons.heartSmall,
            width: 16,
            colorFilter: ColorFilter.mode(
              sensor.isHrOk ? AppColors.gray186 : theme.colorScheme.error,
              BlendMode.srcIn,
            ),
          );
        },
      ),
    );
  }
}

class _IndicatorWidget extends StatelessWidget {
  const _IndicatorWidget({required this.sensor});

  final SensorEntity sensor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider<SensorEntity>.value(
      value: sensor,
      child: Consumer<SensorEntity>(
        builder: (context, sensor, child) {
          final status = sensor.status;
          return ClipOval(
            child: SizedBox(
              width: 8,
              height: 8,
              child: ColoredBox(
                color: switch (status) {
                  SensorStatus.connected => theme.primaryColor,
                  SensorStatus.timeout => AppColors.yellow,
                  SensorStatus.disconnected => AppColors.red,
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
