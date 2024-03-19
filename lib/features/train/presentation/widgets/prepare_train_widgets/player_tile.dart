import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/core/presentation/app_icon_button.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';

class PlayerTile extends StatelessWidget {
  const PlayerTile({super.key, required this.player});

  final PlayerEntity player;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppContainer(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      borderRadius: BorderRadius.circular(16),
      child: Row(
        children: [
          Switch(value: true, onChanged: (val) {}),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${player.number} ${player.name}",
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "device id",
                  style: theme.textTheme.displaySmall,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
          SvgPicture.asset(AppIcons.heartGray, width: 20,),
          const SizedBox(width: 8),
          AppIconButton(
            icon: SvgPicture.asset(AppIcons.edit),
            onPressed: () {},
            size: 30,
          ),
          const SizedBox(width: 8),
          SvgPicture.asset(AppIcons.battery100, height: 30),
          const SizedBox(width: 8),
          const _IndicatorWidget(enable: true),
        ],
      ),
    );
  }
}

class _IndicatorWidget extends StatelessWidget {
  const _IndicatorWidget({super.key, required this.enable});

  final bool enable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipOval(
      child: SizedBox(
        width: 8,
        height: 8,
        child: ColoredBox(
          color: theme.primaryColor,
        ),
      ),
    );
  }
}
