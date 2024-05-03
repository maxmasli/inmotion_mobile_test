import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/train_widgets/prepare_train_widgets/prepare_train_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/train_widgets/running_train_widgets/running_train_widget.dart';
import 'package:provider/provider.dart';

class TrainBody extends StatelessWidget {
  const TrainBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<TrainModel, TrainStage>(
      selector: (context, model) => model.trainStage,
      builder: (context, stage, child) {
        return switch(stage) {
          TrainStage.prepare => const PrepareTrainWidget(),

          // TODO: Handle this case.
          TrainStage.running =>  const RunningTrainWidget(),
          // TODO: Handle this case.
          TrainStage.end => throw UnimplementedError(),
        };
      },
    );
  }
}
