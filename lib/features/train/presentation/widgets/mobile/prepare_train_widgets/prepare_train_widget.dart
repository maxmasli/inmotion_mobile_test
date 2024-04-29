import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/mobile/prepare_train_widgets/bluetooth_empty_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/mobile/prepare_train_widgets/device_tile.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/mobile/prepare_train_widgets/player_tile.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';
import 'package:provider/provider.dart';

class PrepareTrainWidget extends StatelessWidget {
  const PrepareTrainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // TODO переделать на Selector
    final model = context.watch<TrainModel>();
    return Expanded(
      child: ListView(
        children: [
          if (model.players.isEmpty)
            const BluetoothEmptyWidget()
          else
            for (final player in model.players) ...[
              PlayerTile(player: player),
              const SizedBox(height: 8),
            ],
          const SizedBox(height: 12),
          AppContainer(
            borderRadius: BorderRadius.circular(16),
            padding: const EdgeInsets.all(10),
            onTap: () {},
            color: theme.colorScheme.secondaryContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Добавить устроиство",
                  style: theme.textTheme.labelSmall,
                ),
                SvgPicture.asset(AppIcons.add)
              ],
            ),
          ),
          const SizedBox(height: 12),
          for (final device in model.foundedDevices) ...[
            DeviceTile(
              device: device,
              onTap: () async {
                await model.saveDevice(device);
              },
            ),
            const SizedBox(height: 8),
          ]
        ],
      ),
    );
  }
}
