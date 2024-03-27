import 'package:inmotion_mobile_test/core/domain/usecases/usecase.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/sensor_players_repository.dart';

class SavePlayerSensorUseCase implements UseCase<void, PlayersParams> {

  final SensorPlayersRepository sensorPlayersRepository;

  const SavePlayerSensorUseCase({
    required this.sensorPlayersRepository,
  });

  @override
  Future<void> call(PlayersParams params) async {
    assert(params.player.hasSensor, 'Player to save has no sensor');
    return await sensorPlayersRepository.savePlayer(params.player);
  }
}
