import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/prepare_train_widgets/bluetooth_empty_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/prepare_train_widgets/device_tile.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/prepare_train_widgets/player_tile.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/train_history_sheet.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';
import 'package:provider/provider.dart';

class PrepareTrainWidget extends StatelessWidget {
  const PrepareTrainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final model = context.watch<TrainModel>();
    return Expanded(
      child: ListView(
        padding: EdgeInsets.only(bottom: height * bottomSheetMinHeight - 15),
        children: [
          if (model.players.isEmpty)
            const BluetoothEmptyWidget()
          else
            for (final player in model.players) ...[PlayerTile(player: player)],
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
              onTap: () {
                model.saveDevice(device);
              },
            )
          ]
        ],
      ),
    );
    // return Expanded(
    //   child: Column(
    //     children: [
    //       if (model.isBLEOn && model.hasAllPermissions)
    //         if (model.devices.isEmpty)
    //           const CircularProgressIndicator()
    //         else
    //           Expanded(
    //             child: ListView.builder(
    //               shrinkWrap: true,
    //               itemCount: model.devices.length,
    //               padding: EdgeInsets.only(
    //                 bottom: height * bottomSheetMinHeight - 20,
    //               ),
    //               itemBuilder: (context, i) {
    //                 return Text(model.devices[i].advName);
    //               },
    //             ),
    //           )
    //       else
    //         const BluetoothOffWidget()
    //     ],
    //   )
    // );
  }
}
