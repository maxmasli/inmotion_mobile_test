import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/colors.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:provider/provider.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class PlayerMapWidget extends StatefulWidget {
  const PlayerMapWidget({super.key});

  @override
  State<PlayerMapWidget> createState() => _PlayerMapWidgetState();
}

class _PlayerMapWidgetState extends State<PlayerMapWidget> {
  late final YandexMapController _mapController;

  Iterable<MapObject> _getMapObjectsFromData(
      Iterable<(double x, double y, int speed)> data) sync* {
    yield PolylineMapObject(
        mapId: MapObjectId("asd"),
        polyline: Polyline(
          points: data
              .map((data) => Point(latitude: data.$1, longitude: data.$2))
              .toList(),
        ),
        strokeColor: Colors.orange,
        strokeWidth: 8);

    final last = data.lastOrNull;
    if (last == null) return;

    yield PlacemarkMapObject(
      mapId: const MapObjectId("123"),
      point: Point(latitude: last.$1, longitude: last.$2),
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
          image: BitmapDescriptor.fromAssetImage('assets/icons/map_point.png'),
          scale: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const height = 250.0;
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.primaryColor)
      ),
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Consumer<PlayerEntity>(
          builder: (context, player, child) {
            final cords = player.coordinates;
            return Stack(
              children: [
                YandexMap(
                  logoAlignment: const MapAlignment(
                      horizontal: HorizontalAlignment.left,
                      vertical: VerticalAlignment.bottom),
                  onMapCreated: (controller) async {
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
                  mapObjects: _getMapObjectsFromData(cords).toList(),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () async {
                      final last = cords.lastOrNull;
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
                          cords.lastOrNull?.$3.toString() ?? "0",
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
          },
        ),
      ),
    );
  }
}
