import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';
import 'package:provider/provider.dart';

class StatusWidget extends StatelessWidget {
  const StatusWidget({super.key, this.size = 86});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Selector<TrainModel, SystemStatus>(
      selector: (context, model) => model.systemStatus,
      shouldRebuild: (prev, next) => prev != next,
      builder: (context, systemStatus, child) {
        return AppContainer(
          height: size,
          width: size,
          borderRadius: BorderRadius.circular(1000),
          padding: const EdgeInsets.all(8),
          child: SvgPicture.asset(
            switch (systemStatus) {
              SystemStatus.off => AppIcons.off,
              SystemStatus.ready => AppIcons.ready,
              SystemStatus.rec => AppIcons.rec,
              SystemStatus.error => AppIcons.error,
            },
          ),
        );
      },
    );
  }
}
