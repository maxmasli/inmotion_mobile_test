import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/core/presentation/round_number_widget.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/sensor_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:provider/provider.dart';

class SatelliteInfoWidget extends StatelessWidget {
  const SatelliteInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Selector<TrainModel, List<PlayerEntity>>(
      selector: (context, model) => model.players,
      builder: (context, list, child) {
        return AppContainer(
          padding: const EdgeInsets.all(12),
          borderRadius: BorderRadius.circular(100),
          child: Row(
            children: [
              RoundNumberWidget(
                number: list
                    .where((p) => p.sensor!.status != SensorStatus.connected)
                    .length,
              ),
              const SizedBox(width: 10),
              Text(
                "Подключенны к спутникам",
                style: theme.textTheme.headlineSmall,
              )
            ],
          ),
        );
      },
    );
  }
}
