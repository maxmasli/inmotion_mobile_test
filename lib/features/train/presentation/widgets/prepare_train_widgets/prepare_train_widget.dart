import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_provider.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/prepare_train_widgets/bluetooth_off_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/train_body.dart';
import 'package:provider/provider.dart';

class PrepareTrainWidget extends StatelessWidget {
  const PrepareTrainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final model = context.watch<TrainModel>();
    return Expanded(
      child: Column(
        children: [
          if (model.isBLEOn && model.hasAllPermissions)
            if (model.devices.isEmpty)
              const CircularProgressIndicator()
            else
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: model.devices.length,
                  padding: EdgeInsets.only(
                    bottom: height * bottomSheetMinHeight - 20,
                  ),
                  itemBuilder: (context, i) {
                    return Text(model.devices[i].advName);
                  },
                ),
              )
          else
            const BluetoothOffWidget()
        ],
      )
    );
  }
}
