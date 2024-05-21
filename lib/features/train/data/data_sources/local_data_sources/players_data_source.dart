import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:inmotion_mobile_test/features/train/data/DTOs/player_dto.dart';
import 'package:inmotion_mobile_test/features/train/data/DTOs/player_list_dto.dart';

abstract interface class PlayersDataSource {
  Future<void> savePlayers(String key, PlayerListDTO players);
  Future<PlayerListDTO> getPlayers(String key);
  Future<void> deletePlayers(String key, PlayerListDTO players);
  Future<void> deleteAllPlayers(String key);
  Future<void> updatePlayer(String key, PlayerDTO player);
}

class PlayersDataSourceImpl implements PlayersDataSource {
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

  @override
  Future<void> deletePlayers(String key, PlayerListDTO players) async {
    log('Delete players with key: $key, length: ${players.list.length}', name: 'PlayersDataSourceImpl');
    final box = await _openBox();
    final playersList = box.get(key, defaultValue: const PlayerListDTO(list: []));
    final formedList = PlayerListDTO(list: [...playersList!.list]);
    for (final player in playersList.list) {
      for (final delPlayer in players.list) {
        if (player.uuid != delPlayer.uuid) {
          continue;
        }
        formedList.list.remove(player);
        break;
      }
    }
    await box.delete(key);
    await box.put(key, formedList);
    await box.close();
  }


  @override
  Future<void> updatePlayer(String key, PlayerDTO player) async {
    log('Update player with key: $key, name: ${player.name}', name: 'PlayersDataSourceImpl');
    final box = await _openBox();
    final playersList = box.get(key, defaultValue: const PlayerListDTO(list: []));
    final updatedList = <PlayerDTO>[];
    for (var savedPlayer in playersList!.list) {
      if (savedPlayer.uuid == player.uuid) {
        savedPlayer = player;
        updatedList.add(savedPlayer);
      } else {
        updatedList.add(savedPlayer);
      }
    }
    await box.delete(key);
    await box.put(key, PlayerListDTO(list: updatedList));
    await box.close();
  }

  @override
  Future<void> deleteAllPlayers(String key) async {
    log('Delete all players with key: $key', name: 'PlayersDataSourceImpl');
    final box = await _openBox();
    await box.delete(key);
    await box.close();
  }

  Future<Box<PlayerListDTO>> _openBox() async {
    const boxName = 'players';
    return await Hive.openBox(boxName);
  }
}
