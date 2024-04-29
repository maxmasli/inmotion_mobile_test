import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/colors.dart';
import 'package:inmotion_mobile_test/core/utils/utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class PlayerLineChart extends StatefulWidget {
  const PlayerLineChart({super.key, required this.data});

  final Iterable<(double x, double y, int speed)> data;

  @override
  State<PlayerLineChart> createState() => _PlayerLineChartState();
}

class _PlayerLineChartState extends State<PlayerLineChart> {
  late final YandexMapController _mapController;

  // List<MapObject> _getMapObjectsFromData() {
  //   return widget.data
  //       .map(
  //         (data) => PlacemarkMapObject(
  //           mapId: MapObjectId('MapObject ${data.$1} ${data.$2} ${data.$3}'),
  //           point: Point(latitude: data.$1, longitude: data.$2),
  //           opacity: 1,
  //           icon: PlacemarkIcon.single(
  //             PlacemarkIconStyle(
  //               image: BitmapDescriptor.fromAssetImage(
  //                 getPointPathBySpeed(data.$3),
  //               ),
  //               scale: 1,
  //             ),
  //           ),
  //         ),
  //       )
  //       .toList();
  // }

  Iterable<MapObject> _getMapObjectsFromData() sync* {
    // Point? startPoint;
    // for (final data in widget.data) {
    //   if (startPoint != null) {
    //     yield PolylineMapObject(
    //       mapId: MapObjectId("${data.$1} ${data.$2} ${data.$3}"),
    //       polyline: Polyline(
    //         points: [
    //           startPoint,
    //           Point(latitude: data.$1, longitude: data.$2)
    //         ],
    //       ),
    //       strokeColor: getColorBySpeed(data.$3),
    //       strokeWidth: 6
    //     );
    //   }
    //   startPoint = Point(latitude: data.$1, longitude: data.$2);
    // }

    yield PolylineMapObject(
        mapId: MapObjectId("asd"),
        polyline: Polyline(
          points: widget.data
              .map((data) => Point(latitude: data.$1, longitude: data.$2))
              .toList(),
        ),
        strokeColor: Colors.orange,
        strokeWidth: 8);

    final last = widget.data.lastOrNull;
    if (last == null) return;

    yield PlacemarkMapObject(
      mapId: const MapObjectId("123"),
      point: Point(
          latitude: last.$1, longitude: last.$2
      ),
      icon: PlacemarkIcon.single(
                PlacemarkIconStyle(
                  image: BitmapDescriptor.fromAssetImage(
                    'assets/icons/map_point.png'
                  ),
                  scale: 1,
                ),
              ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        YandexMap(
          logoAlignment: const MapAlignment(
              horizontal: HorizontalAlignment.left,
              vertical: VerticalAlignment.bottom),
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
          mapObjects: _getMapObjectsFromData().toList(),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            onPressed: () async {
              final last = widget.data.lastOrNull;
              if (last == null) return;
              await _mapController.moveCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: Point(
                      latitude: last.$1,
                      longitude: last.$2,
                    ),
                    zoom: 30,
                  ),
                ),
                animation: const MapAnimation(
                    duration: 0.5, type: MapAnimationType.smooth),
              );
            },
            icon: const Icon(Icons.navigation_outlined),
          ),
        ),
        Positioned(
          right: 8,
          bottom: 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.darkBlue),
                ),
                child: Text(
                  widget.data.lastOrNull?.$3.toString() ?? "0",
                  style: theme.textTheme.labelMedium
                      ?.copyWith(color: AppColors.darkBlue),
                ),
              ),
              // TODO переделать с intl
              Text(
                "км/ч",
                style: theme.textTheme.displaySmall,
              )
            ],
          ),
        )
      ],
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
