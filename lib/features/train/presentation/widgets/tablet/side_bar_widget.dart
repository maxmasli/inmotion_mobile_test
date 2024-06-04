import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/info_text.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/logo_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/navigate_button.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';

class SideBarWidget extends StatelessWidget {
  const SideBarWidget({
    super.key,
    required this.currentScreenIndex,
    required this.onHomeTap,
    required this.onReportsTap,
    required this.onExitTap,
  });

  final int currentScreenIndex;
  final VoidCallback onHomeTap;
  final VoidCallback onReportsTap;
  final VoidCallback onExitTap;

  @override
  Widget build(BuildContext context) {
    //TODO intl
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LogoWidget(),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: NavigateButton(
            text: "Главная",
            icon: SvgPicture.asset(AppIcons.home),
            onTap: onHomeTap,
            isSelected: 0 == currentScreenIndex,
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: NavigateButton(
            text: "Отчеты",
            icon: SvgPicture.asset(AppIcons.report),
            onTap: onReportsTap,
            isSelected: 1 == currentScreenIndex,
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: NavigateButton(
            text: "Выйти",
            icon: SvgPicture.asset(AppIcons.exit),
            onTap: onExitTap,
            isSelected: false,
          ),
        ),
        const InfoText(),
      ],
    );
  }
}
