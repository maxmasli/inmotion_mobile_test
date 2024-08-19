import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/colors.dart';
import 'package:inmotion_mobile_test/core/presentation/app_container.dart';
import 'package:inmotion_mobile_test/core/utils/utils.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class PlayerMapWidget extends StatefulWidget {
  const PlayerMapWidget({
    super.key,
    required this.player,
  });

  final PlayerEntity player;

  @override
  State<PlayerMapWidget> createState() => _PlayerMapWidgetState();
}

class _PlayerMapWidgetState extends State<PlayerMapWidget> {
  late final YandexMapController _mapController;

  static List<MapObject> _getMapObjectsFromData(
      List<(double x, double y, int speed)> data) {
    final result = <MapObject>[];
    Point? firstPoint;
    for (final d in data) {
      if (firstPoint == null) {
        firstPoint = Point(latitude: d.$1, longitude: d.$2);
        continue;
      }
      final secondPoint = Point(latitude: d.$1, longitude: d.$2);
      result.add(PolylineMapObject(
        mapId: MapObjectId("id_$d"),
        polyline: Polyline(
          points: [firstPoint, secondPoint],
        ),
        strokeColor: getColorBySpeed(d.$3),
        strokeWidth: 8,
      ));

      firstPoint = secondPoint;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cords = widget.player.coordinates;
    return AppContainer(
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.primaryColor)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: YandexMap(
                  logoAlignment: const MapAlignment(
                    horizontal: HorizontalAlignment.left,
                    vertical: VerticalAlignment.bottom,
                  ),
                  onMapCreated: (controller) async {
                    print("map created");
                    _mapController = controller;
                    final last = cords.lastOrNull;
                    await _mapController.moveCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: Point(
                            latitude: last?.$1 ?? 50,
                            longitude: last?.$2 ?? 20,
                          ),
                          zoom: 30,
                        ),
                      ),
                    );
                  },
                  mapObjects: _getMapObjectsFromData(cords.toList()),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: Row(
              children: [
                Container(
                  width: 12,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: AppColors.runColorRanges)),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Макс. скорость', style: theme.textTheme.displaySmall),
                    Text('Средний бег', style: theme.textTheme.displaySmall),
                    Text('Легкий бег', style: theme.textTheme.displaySmall),
                    Text('Ходьба', style: theme.textTheme.displaySmall),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
