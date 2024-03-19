import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';
import 'package:provider/provider.dart';

class StatusWidget extends StatelessWidget {
  const StatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TrainModel>();
    return AppContainer(
      height: 86,
      width: 86,
      borderRadius: BorderRadius.circular(1000),
      padding: const EdgeInsets.all(8),
      child: SvgPicture.asset(
        switch (model.systemStatus) {
          SystemStatus.off => AppIcons.off,
          SystemStatus.rec => AppIcons.rec,
          SystemStatus.error => AppIcons.error,
        },
      ),
    );
  }
}
