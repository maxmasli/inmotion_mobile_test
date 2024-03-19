import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_provider.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/train_body.dart';
import 'package:provider/provider.dart';

class PrepareTrainWidget extends StatelessWidget {
  const PrepareTrainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final model = context.watch<TrainModel>();
    return Expanded(
      child: ListView(
        padding: EdgeInsets.only(
          bottom: height * bottomSheetMinHeight - 20,
        ),
        children: [
          if (model.isBLEOn) Text("ON")
          else const Text("OFF")
        ],
      ),
    );
  }
}
