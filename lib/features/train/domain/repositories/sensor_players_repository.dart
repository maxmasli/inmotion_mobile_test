import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';

abstract interface class SensorPlayersRepository {
  Future<void> savePlayer(PlayerEntity playerEntity);
  Future<List<PlayerEntity>> getPlayers();
}