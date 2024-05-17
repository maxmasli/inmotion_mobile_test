import 'package:inmotion_mobile_test/core/domain/usecases/usecase.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/players_repository.dart';

class UpdatePlayerUseCase implements UseCase<void, TrainPlayerParams> {
  final PlayersRepository playerRepository;

  const UpdatePlayerUseCase({
    required this.playerRepository,
  });

  @override
  Future<void> call(TrainPlayerParams params) async {
    return await playerRepository.updatePlayer(
      params.train.playersKey!,
      params.player,
    );
  }
}
