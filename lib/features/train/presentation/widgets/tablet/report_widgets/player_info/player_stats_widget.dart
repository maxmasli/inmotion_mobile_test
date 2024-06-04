import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inmotion_mobile_test/core/presentation/app_button.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/core/utils/stats_calculator.dart';
import 'package:inmotion_mobile_test/core/utils/utils.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/player_info/player_hr_bar_chart.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/player_info/player_hr_line_chart.dart';

class PlayerStatsWidget extends StatelessWidget {
  const PlayerStatsWidget({
    super.key,
    required this.player,
    required this.train,
  });

  final PlayerEntity player;
  final TrainEntity train;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${player.number} ${player.name}',
                      style: theme.textTheme.headlineMedium,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'TRIMP ${StatsCalculator.getTrimp(player)}',
                      style: theme.textTheme.headlineMedium,
                    ),
                    Text(
                      formatDuration(
                          train.endTime!.difference(train.startTime)),
                      style: theme.textTheme.displaySmall,
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _InfoWidget(
                    value: "${StatsCalculator.calculateMaxPulse(player)}",
                    info: "Макс. HR",
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _InfoWidget(
                    value: "${StatsCalculator.calculateMinPulse(player)}",
                    info: "Мин. HR",
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _InfoWidget(
                    value: "${StatsCalculator.calculateAvgPulse(player)}",
                    info: "Средн. HR",
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _InfoWidget(
                    value: "${player.distance}",
                    info: "Пройденное расстояние",
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _InfoWidget(
                    value: "${player.avgSpeedKph.toInt()} км/ч",
                    info: "Средн. скорость",
                  ),
                ),
              ],
            ),
            PlayerHrBarChart(
              player: player,
            ),
            const SizedBox(height: 10),
            PlayerHrLineChart(
              player: player,
            ),
            const SizedBox(height: 10),
            AppButton(
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.all(8),
              onTap: () {},
              child: Center(
                child: Text(
                  'Скачать Excel',
                  style: theme.textTheme.labelSmall,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _InfoWidget extends StatelessWidget {
  const _InfoWidget({
    required this.value,
    required this.info,
  });

  final String value;
  final String info;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          info,
          style: theme.textTheme.displaySmall,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
