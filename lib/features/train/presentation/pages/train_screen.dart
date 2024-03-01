import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_provider.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/main_body.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';
import 'package:provider/provider.dart';

@RoutePage()
class TrainScreen extends StatelessWidget {
  const TrainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TrainModel()..init(),
      child: Scaffold(
        appBar: AppBar(
          title: SvgPicture.asset(AppIcons.logo, width: 120),
        ),
        body: const MainBody(),
      ),
    );
  }
}
