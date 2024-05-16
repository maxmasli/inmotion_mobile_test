import 'package:inmotion_mobile_test/core/domain/usecases/usecase.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/players_repository.dart';

class DeletePlayersFromTrainUseCase implements UseCase<void, TrainPlayerListParams> {
  final PlayersRepository playersRepository;

  const DeletePlayersFromTrainUseCase({
    required this.playersRepository,
  });

  @override
  Future<void> call(TrainPlayerListParams params) async {
    return await playersRepository.deletePlayers(
      params.train.playersKey!,
      params.players,
    );
  }
}
