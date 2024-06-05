import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/colors.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/core/presentation/round_number_widget.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/sensor_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:provider/provider.dart';

class DeviceInfoWidget extends StatelessWidget {
  const DeviceInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final model = context.watch<TrainModel>();
    final list = model.players;
    return AppContainer(
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(100),
      child: Row(
        children: [
          RoundNumberWidget(
            number: list
                .where((p) => p.sensor!.status == SensorStatus.connected)
                .length,
            color: AppColors.green,
          ),
          const SizedBox(width: 10),
          Text(
            "Включены",
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(width: 20),
          const RoundNumberWidget(
            number: 0,
            color: AppColors.orange,
          ),
          const SizedBox(width: 10),
          Text(
            "Разряжены",
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(width: 20),
          RoundNumberWidget(
            number: list
                .where((p) => p.sensor!.status != SensorStatus.connected)
                .length,
            color: AppColors.red,
          ),
          const SizedBox(width: 10),
          Text(
            "Выключены",
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(width: 20),
          RoundNumberWidget(
            number: list
                .where((p) => p.sensor!.isHrOk)
                .length,
          ),
          const SizedBox(width: 10),
          Text(
            "ЧСС",
            style: theme.textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}
