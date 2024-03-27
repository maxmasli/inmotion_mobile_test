import 'package:inmotion_mobile_test/core/domain/usecases/usecase.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/players_repository.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/sensor_players_repository.dart';

class GetPlayersSensorUseCase
    implements UseCase<List<PlayerEntity>, EmptyParams> {
  final SensorPlayersRepository sensorPlayersRepository;

  const GetPlayersSensorUseCase({
    required this.sensorPlayersRepository,
  });

  @override
  Future<List<PlayerEntity>> call([EmptyParams? params]) async {
    final players = await sensorPlayersRepository.getPlayers();
    for (var player in players) {
      assert(player.hasSensor, 'Saved players has no sensor');
    }
    return players;
  }
}
