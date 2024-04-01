import 'dart:developer';

import 'package:inmotion_mobile_test/features/train/data/DTOs/player_dto.dart';
import 'package:inmotion_mobile_test/features/train/data/DTOs/player_list_dto.dart';
import 'package:inmotion_mobile_test/features/train/data/data_sources/local_data_sources/players_data_source.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/players_repository.dart';

class PlayersRepositoryImpl implements PlayersRepository {
  final PlayersDataSource playersDataSource;

  const PlayersRepositoryImpl({
    required this.playersDataSource,
  });

  @override
  Future<void> deletePlayers(String key) async {
    return await playersDataSource.deletePlayers(key);
  }

  @override
  Future<List<PlayerEntity>> getPlayers(String key) async {
    return (await playersDataSource.getPlayers(key))
        .list
        .map((p) => p.toEntity())
        .toList();
  }

  @override
  Future<void> savePlayers(String key, Iterable<PlayerEntity> players) async {
    log('List<PlayerEntity> to PlayerListDTO, length: ${players.length}', name: 'PlayersRepositoryImpl');
    return await playersDataSource.savePlayers(
        key,
        PlayerListDTO(
            list: players.map((p) => PlayerDTO.fromEntity(p)).toList()));
  }
}
