import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/colors.dart';
import 'package:inmotion_mobile_test/core/utils/settings.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PlayerHrLineChart extends StatelessWidget {
  const PlayerHrLineChart({super.key, required this.player});

  final PlayerEntity player;

  List<ChartData> _toChartData(PlayerEntity player) {
    final first =
    player.measures.firstWhereOrNull((m) => m.time != null && m.hr != null);
    if (first == null) return [];
    return player.measures
        .where((m) => m.hr != null && m.time != null)
        .map((m) {
      final diff = m.time!.difference(first.time!);
      return ChartData(
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            diff.inHours.remainder(24),
            diff.inMinutes.remainder(60),
            diff.inSeconds.remainder(60),
          ),
          m.hr!);
    }).toList();
    //return player.measures.where((m) => m.time != null && m.hr != null).map((m) => ChartData(m.time!, m.hr!)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 200,
      child: SfCartesianChart(
        margin: EdgeInsets.zero,
        plotAreaBorderColor: Colors.transparent,
        primaryYAxis: NumericAxis(
          maximum: 200,
          minimum: 40,
          interval: 20,
          plotBands: [
            PlotBand(
              start: Settings.maximumIntensity,
              end: Settings.maximumIntensity + 30,
              color: AppColors.colorRanges[4],
              opacity: 0.3,
            ),
            PlotBand(
              start: Settings.anaerobicMode,
              end: Settings.anaerobicMode +
                  (Settings.maximumIntensity - Settings.anaerobicMode),
              color: AppColors.colorRanges[3],
              opacity: 0.3,
            ),
            PlotBand(
              start: Settings.aerobicMode,
              end: Settings.aerobicMode +
                  (Settings.anaerobicMode - Settings.aerobicMode),
              color: AppColors.colorRanges[2],
              opacity: 0.3,
            ),
            PlotBand(
              start: Settings.lightLoad,
              end: Settings.lightLoad +
                  (Settings.aerobicMode - Settings.lightLoad),
              color: AppColors.colorRanges[1],
              opacity: 0.3,
            ),
            PlotBand(
              start: 40,
              end: Settings.lightLoad,
              color: AppColors.colorRanges[0],
              opacity: 0.3,
            ),
          ],
          labelStyle: theme.textTheme.displaySmall?.copyWith(fontSize: 10),
          axisLine: const AxisLine(
            color: Colors.transparent,
          ),
          majorGridLines:
          const MajorGridLines(color: Colors.grey, width: 0.5),
          minorGridLines: const MinorGridLines(color: Colors.transparent),
          majorTickLines: const MajorTickLines(color: Colors.transparent),
          minorTickLines: const MinorTickLines(color: Colors.transparent),
        ),
        primaryXAxis: DateTimeAxis(
          axisLine: const AxisLine(
            color: Colors.grey,
            width: 0.5,
          ),
          labelStyle: theme.textTheme.displaySmall,
          majorGridLines:
          const MajorGridLines(color: Colors.grey, width: 0.5),
          minorGridLines: const MinorGridLines(color: Colors.transparent),
          majorTickLines: const MajorTickLines(color: Colors.transparent),
          minorTickLines: const MinorTickLines(color: Colors.transparent),
          dateFormat: DateFormat("mm:ss"),
        ),
        series: [
          FastLineSeries<ChartData, DateTime>(
            animationDuration: 0,
            dataSource: _toChartData(player),
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
          )
        ],
      ),
    );
  }
}

class ChartData {
  final DateTime x;
  final int y;

  ChartData(this.x, this.y);
}
