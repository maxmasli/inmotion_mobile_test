import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/utils/utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PlayerLineChart extends StatelessWidget {
  const PlayerLineChart({super.key, required this.data});

  final List<(int x, int y, int speed)> data;

  // // 36000
  // final List<ChartData> chartData = [
  //   ChartData(5, 5),
  //   ChartData(20, 40),
  //   ChartData(30, -20),
  //   ChartData(-10, -10),
  //   ChartData(-50, -50)
  // ];

  // final List<ChartData> chartData = List.generate(
  //   36000,
  //   (index) => ChartData(index % 60, index % 50),
  // );

  @override
  Widget build(BuildContext context) {
    print('build');
    return SfCartesianChart(
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
        enablePanning: true,
        zoomMode: ZoomMode.xy,
        maximumZoomLevel: 0.5,
        enableDoubleTapZooming: true,
      ),
      margin: EdgeInsets.zero,
      primaryYAxis: const NumericAxis(
        interval: 10,
        crossesAt: 0,
        minimum: -60,
        maximum: 60,
        labelStyle: TextStyle(color: Colors.transparent),
        axisLine: AxisLine(color: Colors.transparent),
        majorTickLines: MajorTickLines(color: Colors.transparent),
      ),
      primaryXAxis: const NumericAxis(
        interval: 10,
        crossesAt: 0,
        minimum: -90,
        maximum: 90,
        labelStyle: TextStyle(color: Colors.transparent),
        axisLine: AxisLine(color: Colors.transparent),
        majorTickLines: MajorTickLines(color: Colors.transparent),
      ),
      series: [
        ScatterSeries(
          animationDuration: 0,
          dataSource: data,
          xValueMapper: (data, _) {
            return data.$1;
          },
          yValueMapper: (data, _) {
            return data.$2;
          },
          pointColorMapper: (data, i) => getColorBySpeed(data.$3),
        )
      ],
    );
  }
}

// class ChartData {
//   ChartData(this.x, this.y);
//
//   final int x;
//   final int y;
// }
