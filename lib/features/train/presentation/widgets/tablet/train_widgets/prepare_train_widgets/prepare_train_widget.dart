import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/train_widgets/prepare_train_widgets/founded_device_list_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/train_widgets/prepare_train_widgets/players_list.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/train_widgets/prepare_train_widgets/train_edit_widget.dart';

class PrepareTrainWidget extends StatelessWidget {
  const PrepareTrainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
            child: FoundedDeviceListWidget()
        ),
        SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              TrainEditWidget(),
              SizedBox(height: 10),
              Expanded(child: PlayersList()),
            ],
          ),
        ),
      ],
    );
  }
}
