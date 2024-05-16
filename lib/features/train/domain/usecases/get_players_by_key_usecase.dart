import 'package:inmotion_mobile_test/core/domain/usecases/usecase.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/players_repository.dart';

class GetPlayersByKeyUseCase
    implements UseCase<List<PlayerEntity>, StringParams> {
  const GetPlayersByKeyUseCase({
    required this.playersRepository,
  });

  final PlayersRepository playersRepository;

  @override
  Future<List<PlayerEntity>> call(StringParams params) async {
    final key = params.value;
    return await playersRepository.getPlayers(key);
  }
}
