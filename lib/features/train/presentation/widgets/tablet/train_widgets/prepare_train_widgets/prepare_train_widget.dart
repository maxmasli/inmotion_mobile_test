import 'package:flutter/material.dart';

import 'founded_device_list_widget.dart';
import 'players_list.dart';
import 'train_edit_widget.dart';

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
