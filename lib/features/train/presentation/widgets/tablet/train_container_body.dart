import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/report_body.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/side_bar_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/top_bar_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/train_widgets/train_body.dart';

class TrainContainerBody extends StatefulWidget {
  const TrainContainerBody({super.key});

  @override
  State<TrainContainerBody> createState() => _TrainContainerBodyState();
}

class _TrainContainerBodyState extends State<TrainContainerBody> {
  var _currentScreenIndex = 0;

  final _screens = [
    const TrainBody(),
    const ReportBody(),
  ];

  @override
  Widget build(BuildContext context) {
    const sideBarWidth = 170.0;
    return Row(
      children: [
        const SizedBox(
          width: sideBarWidth,
          child: SideBarWidget(),
        ),
        Expanded(
          child: Column(
            children: [
              const TopBarWidget(),
              Expanded(
                child: IndexedStack(
                  index: _currentScreenIndex,
                  children: _screens,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
