import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inmotion_mobile_test/core/colors.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/core/presentation/app_icon_button.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/sensor_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/prepare_train_widgets/player_edit_dialog.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';
import 'package:provider/provider.dart';

class PlayerTile extends StatelessWidget {
  const PlayerTile({super.key, required this.player});

  final PlayerEntity player;

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
            return AppContainer(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              borderRadius: BorderRadius.circular(16),
              child: Row(
                children: [
                  Switch(
                    value: selectedPlayers.contains(player),
                    onChanged: (val) {
                      model.toggleSelectedPlayers(player);
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${player.number} ${player.name}",
                          style: theme.textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${player.sensor!.number} ${player.sensor!.device.remoteId.str}",
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
                    onPressed: () async {
                      final data = await showDialog<(String, String, String)>(
                        context: context,
                        builder: (context) {
                          return PlayerEditDialog(
                            initFields: (
                              player.name,
                              player.number.toString(),
                              player.sensor!.number.toString() ?? '',
                            ),
                          );
                        },
                      );
                      if (data != null) {
                        await model.updateSensorPlayer(
                            player, data.$1, data.$2, data.$3);
                      }
                    },
                    size: 30,
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(AppIcons.battery100, height: 30),
                  const SizedBox(width: 8),
                  _IndicatorWidget(sensor: player.sensor!),
                ],
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
            width: 20,
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
