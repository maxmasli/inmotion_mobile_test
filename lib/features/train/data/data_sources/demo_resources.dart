import 'package:flutter_blue_plus_windows/flutter_blue_plus_windows.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/demo_player_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/sensor_entity.dart';

final demoPlayersList = <DemoPlayerEntity>[
  DemoPlayerEntity(
    name: "Петров В.",
    number: 6,
    sensor: SensorEntity(device: BluetoothDevice.fromId("FF:FF"), number: 0),
  ),
  DemoPlayerEntity(
    name: "Сергеев Е.",
    number: 10,
    sensor: SensorEntity(device: BluetoothDevice.fromId("FF:FF"), number: 6),
  ),
  DemoPlayerEntity(
    name: "Иванов И.",
    number: 1,
    sensor: SensorEntity(device: BluetoothDevice.fromId("FF:FF"), number: 2),
  )
];
