import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PlayerLineChart extends StatelessWidget {
  PlayerLineChart({super.key});

  // 36000
  final List<ChartData> chartData = [
    ChartData(5, 5),
    ChartData(20, 40),
    ChartData(30, -20),
    ChartData(-10, -10),
    ChartData(-50, -50)
  ];

  // final List<ChartData> chartData = List.generate(
  //   36000,
  //   (index) => ChartData(index % 60, index % 50),
  // );

  @override
  Widget build(BuildContext context) {
    print('build');
    return SfCartesianChart(
      primaryYAxis: NumericAxis(
        interval: 10,
        crossesAt: 0,
        minimum: -60,
        maximum: 60,
      ),
      primaryXAxis: NumericAxis(
        interval: 10,
        crossesAt: 0,
        minimum: -80,
        maximum: 80,
      ),
      series: [
        LineSeries(
          animationDuration: 0,
          dataSource: chartData,
          xValueMapper: (data, _) {
            return data.x;
          },
          yValueMapper: (data, _) {
            return data.y;
          },
          pointColorMapper: (data, i) => i % 2 == 0 ? Colors.green : Colors.red,
        )
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final int x;
  final int y;
}
