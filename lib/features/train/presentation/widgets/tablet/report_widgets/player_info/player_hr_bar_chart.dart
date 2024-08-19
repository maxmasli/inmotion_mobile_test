import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/colors.dart';
import 'package:inmotion_mobile_test/core/utils/stats_calculator.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PlayerHrBarChart extends StatelessWidget {
  const PlayerHrBarChart({super.key, required this.player});

  final PlayerEntity player;

  List<ChartData> _toChartData(PlayerEntity player) {
    // TODO intl
    final hrStats = StatsCalculator.getHrStats(player);
    return [
      ChartData('Умеренная активность', (hrStats[0] * 100).round()),
      ChartData('Легкая нагрузка', (hrStats[1] * 100).round()),
      ChartData('Аэробный режим', (hrStats[2] * 100).round()),
      ChartData('Анаэробный режим', (hrStats[3] * 100).round()),
      ChartData('Макс. интенсивность', (hrStats[4] * 100).round()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 180,
      child: SfCartesianChart(
        margin: EdgeInsets.zero,
        plotAreaBorderColor: Colors.transparent,
        primaryXAxis: CategoryAxis(
          axisLine: const AxisLine(
            color: Colors.transparent,
          ),
          maximumLabels: 3,
          labelIntersectAction: AxisLabelIntersectAction.wrap,

          majorGridLines: const MajorGridLines(color: Colors.transparent),
          majorTickLines: const MajorTickLines(
            color: Colors.transparent,
          ),
          labelStyle: theme.textTheme.displaySmall?.copyWith(fontSize: 8),
        ),
        primaryYAxis: const NumericAxis(
          minimum: 0,
          maximum: 120,
          interval: 20,
          majorGridLines: MajorGridLines(color: Colors.transparent),
          maximumLabelWidth: 0,
          axisLine: AxisLine(
            color: Colors.transparent,
          ),
          majorTickLines: MajorTickLines(
            color: Colors.transparent,
          ),
          minorTickLines: MinorTickLines(color: Colors.transparent),
        ),
        series: [
          ColumnSeries<ChartData, String>(
            animationDuration: 0,
            width: 0.95,
            dataLabelMapper: (data, index) => "${data.y}%",
            dataLabelSettings: DataLabelSettings(
                isVisible: true,
                showCumulativeValues: true,
                showZeroValue: true,
                textStyle: theme.textTheme.headlineMedium?.copyWith(fontSize: 17)
            ),
            dataSource: _toChartData(player),
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            pointColorMapper: (ChartData data, i) => AppColors.colorRanges[i].withOpacity(0.3),
          )
        ],
      ),
    );
  }
}

class ChartData {
  final String x;
  final int y;

  ChartData(this.x, this.y);
}
