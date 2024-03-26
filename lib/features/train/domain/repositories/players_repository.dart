import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';

abstract interface class PlayersRepository {
  Future<void> savePlayers(String key, Iterable<PlayerEntity> players);
  Future<List<PlayerEntity>> getPlayers(String key);
  Future<void> deletePlayers(String key);
}