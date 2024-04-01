import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:inmotion_mobile_test/features/train/data/DTOs/player_list_dto.dart';

abstract interface class PlayersDataSource {
  Future<void> savePlayers(String key, PlayerListDTO players);
  Future<PlayerListDTO> getPlayers(String key);
  Future<void> deletePlayers(String key);
}

class PlayersDataSourceImpl implements PlayersDataSource {
  @override
  Future<void> deletePlayers(String key) async {
    log('Delete players with key: $key', name: 'PlayersDataSourceImpl');
    final box = await _openBox();
    await box.delete(key);
    await box.close();
  }

  @override
  Future<PlayerListDTO> getPlayers(String key) async {
    log('Get players with key: $key', name: 'PlayersDataSourceImpl');
    final box = await _openBox();
    final playerList = box.get(key, defaultValue: const PlayerListDTO(list: []))!;
    await box.close();
    return playerList;
  }

  @override
  Future<void> savePlayers(String key, PlayerListDTO playerList) async {
    log('Save players with key: $key, length: ${playerList.list.length}', name: 'PlayersDataSourceImpl');
    final box = await _openBox();
    await box.put(key, playerList);
    await box.close();
  }

  Future<Box<PlayerListDTO>> _openBox() async {
    const boxName = 'players';
    return await Hive.openBox(boxName);
  }
}
