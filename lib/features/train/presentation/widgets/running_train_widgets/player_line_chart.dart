import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/utils/utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class PlayerLineChart extends StatefulWidget {
  const PlayerLineChart({super.key, required this.data});

  final List<(double x, double y, int speed)> data;

  @override
  State<PlayerLineChart> createState() => _PlayerLineChartState();
}

class _PlayerLineChartState extends State<PlayerLineChart> {
  late final YandexMapController _mapController;

  List<MapObject> _getMapObjectsFromData() {
    return widget.data
        .map(
          (data) => PlacemarkMapObject(
            mapId: MapObjectId('MapObject ${data.$1} ${data.$2}'),
            point: Point(latitude: data.$1, longitude: data.$2),
            opacity: 1,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                  image: BitmapDescriptor.fromAssetImage(
                    'assets/icons/map_point.png',
                  ),
                  scale: 0.8),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return YandexMap(
      onMapCreated: (controller) async {
        _mapController = controller;
        await _mapController.moveCamera(
          CameraUpdate.newCameraPosition(
            const CameraPosition(
              target: Point(
                latitude: 50,
                longitude: 20,
              ),
              zoom: 3,
            ),
          ),
        );
      },
      mapObjects: _getMapObjectsFromData(),

    );
  }

  @override
  void dispose() {
    super.dispose();
    //_mapController.dispose();
  }
}

// @override
// Widget build(BuildContext context) {
//   return SfCartesianChart(
//     zoomPanBehavior: ZoomPanBehavior(
//       enablePinching: true,
//       enablePanning: true,
//       zoomMode: ZoomMode.xy,
//       maximumZoomLevel: 0.5,
//       enableDoubleTapZooming: true,
//     ),
//     margin: EdgeInsets.zero,
//     primaryYAxis: const NumericAxis(
//       crossesAt: 0,
//       labelStyle: TextStyle(color: Colors.transparent),
//       axisLine: AxisLine(color: Colors.transparent),
//       majorTickLines: MajorTickLines(color: Colors.transparent),
//     ),
//     primaryXAxis: const NumericAxis(
//       crossesAt: 0,
//       labelStyle: TextStyle(color: Colors.transparent),
//       axisLine: AxisLine(color: Colors.transparent),
//       majorTickLines: MajorTickLines(color: Colors.transparent),
//     ),
//     series: [
//       ScatterSeries(
//         animationDuration: 0,
//         dataSource: data,
//         xValueMapper: (data, _) {
//           return data.$1;
//         },
//         yValueMapper: (data, _) {
//           return data.$2;
//         },
//         pointColorMapper: (data, i) => getColorBySpeed(data.$3),
//       )
//     ],
//   );
// }
