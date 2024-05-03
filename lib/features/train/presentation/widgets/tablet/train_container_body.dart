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

  void _navigateToTab(int index) {
    setState(() {
      _currentScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const sideBarWidth = 170.0;
    return Row(
      children: [
        SizedBox(
          width: sideBarWidth,
          child: SideBarWidget(
            currentScreenIndex: _currentScreenIndex,
            onHomeTap: () {
              _navigateToTab(0);
            },
            onReportsTap: () {
              _navigateToTab(1);
            },
            onExitTap: () {

            },
          ),
        ),
        Expanded(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: TopBarWidget(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: IndexedStack(
                    index: _currentScreenIndex,
                    children: _screens,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
