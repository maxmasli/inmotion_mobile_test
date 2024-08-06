import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inmotion_mobile_test/di.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/info_text.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/logo_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/navigate_button.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';
import 'package:provider/provider.dart';
import 'package:talker_flutter/talker_flutter.dart';

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
    final theme = Theme.of(context);
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
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: NavigateButton(
            text: "Debug",
            icon: SvgPicture.asset(AppIcons.report),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TalkerScreen(talker: getIt<Talker>()),
              ));
            },
            isSelected: 2 == currentScreenIndex,
          ),
        ),
        const SizedBox(height: 16),
        Selector<TrainModel, bool>(
          selector: (context, TrainModel model) => model.hasDemoPlayers,
          builder: (context, value, child) {
            final model = context.read<TrainModel>();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Text("Демо игроки", style: theme.textTheme.displaySmall),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: 42,
                    height: 30,
                    child: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: model.hasDemoPlayers,
                        onChanged: (value) {
                          model.toggleDemoPlayers(value);
                        },
                      ),
                    ),
                  )
                ],
              ),
            );
          },
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
