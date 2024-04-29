import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inmotion_mobile_test/core/utils/utils.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/mobile/train_body.dart'
    as mobile;
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/train_container_body.dart'
    as tablet;
import 'package:inmotion_mobile_test/resources/resources.dart';
import 'package:provider/provider.dart';

@RoutePage()
class TrainScreen extends StatelessWidget {
  const TrainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= minTabletSize;
    return ChangeNotifierProvider(
      create: (context) => TrainModel()..init(),
      child: Scaffold(
        appBar: !isTablet
            ? AppBar(
                title: SvgPicture.asset(AppIcons.logo, width: 120),
              )
            : null,
        body: isTablet ? const tablet.TrainContainerBody() : const mobile.TrainBody(),
      ),
    );
  }
}
