import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/core/utils/stats_calculator.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/train_widgets/running_train_widgets/player_hr_bar_chart.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/train_widgets/running_train_widgets/player_hr_line_chart.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/train_widgets/running_train_widgets/player_map_widget.dart';
import 'package:inmotion_mobile_test/resources/resources.dart';
import 'package:provider/provider.dart';

class PlayerInfoWidget extends StatelessWidget {
  const PlayerInfoWidget({super.key, required this.player});

  final PlayerEntity player;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider.value(
      value: player,
      child: AppContainer(
        padding: const EdgeInsets.all(12),
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${player.number} ${player.name}",
                        style: theme.textTheme.headlineMedium,
                      ),
                      Text(
                        player.sensor!.device.remoteId.str,
                        style: theme.textTheme.displaySmall,
                      )
                    ],
                  ),
                  const _PlayerStats()
                ],
              ),
              const PlayerMapWidget(),
              const SizedBox(height: 12),
              const PlayerHrBarChart(),
              const SizedBox(height: 12),
              const PlayerHrLineChart(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayerStats extends StatelessWidget {
  const _PlayerStats();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme.labelMedium;
    return Consumer<PlayerEntity>(
      builder: (context, player, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  AppIcons.heart,
                  width: 14,
                  height: 14,
                  colorFilter: ColorFilter.mode(
                    textTheme!.color!,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  player.measures.lastOrNull?.hr.toString() ?? "0",
                  style: textTheme.copyWith(fontSize: 34),
                )
              ],
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "TRIMP",
                      style: textTheme.copyWith(fontSize: 10),
                    ),
                    SizedBox(
                      height: 1,
                      width: 24,
                      child: ColoredBox(
                        color: textTheme.color!,
                      ),
                    ),
                    Text(
                      'min',
                      style: textTheme.copyWith(fontSize: 10),
                    )
                  ],
                ),
                const SizedBox(width: 10),
                Text(
                  StatsCalculator.getTrimpPerMinute(player).toStringAsFixed(1),
                  style: textTheme.copyWith(fontSize: 34),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
