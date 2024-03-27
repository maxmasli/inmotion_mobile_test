import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:inmotion_mobile_test/features/train/data/DTOs/player_dto.dart';

abstract interface class SensorPlayerDataSource {
  Future<void> savePlayer(PlayerDTO player);
  Future<List<PlayerDTO>> getPlayers();
}

class SensorPlayerDataSourceImpl implements SensorPlayerDataSource {
  @override
  Future<List<PlayerDTO>> getPlayers() async {
    log('Get players with sensors', name: 'SensorPlayerDataSourceImpl');
    final box = await _openBox();
    final list = box.values.toList();
    await box.close();
    return list;
  }

  @override
  Future<void> savePlayer(PlayerDTO player) async {
    log('Save player with sensor: ${player.deviceId}', name: 'SensorPlayerDataSourceImpl');
    final box = await _openBox();
    await box.add(player);
    await box.close();
  }

  Future<Box<PlayerDTO>> _openBox() async {
    const boxName = 'sensor_players';
    return await Hive.openBox(boxName);
  }
}
