import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/train_widgets/prepare_train_widgets/add_device_tile.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/train_widgets/prepare_train_widgets/device_tile.dart';
import 'package:provider/provider.dart';

class FoundedDeviceListWidget extends StatelessWidget {
  const FoundedDeviceListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<TrainModel>();
    return Selector<TrainModel, List<BluetoothDevice>>(
      selector: (context, model) => model.foundedDevices,
      builder: (context, devices, child) {
        return ListView(
          padding: EdgeInsets.zero,
          children: [
            const AddDeviceTile(),
            for (final device in devices) ...[
              const SizedBox(height: 10),
              DeviceTile(
                onTap: () async {
                  await model.saveDevice(device);
                },
                device: device,
              )
            ]
          ],
        );
      },
    );
  }
}
