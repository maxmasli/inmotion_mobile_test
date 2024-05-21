import 'package:inmotion_mobile_test/core/domain/usecases/usecase.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/players_repository.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/train_repository.dart';

class DeleteTrainsUseCase implements UseCase<void, TrainsListParams> {

  final TrainRepository trainRepository;
  final PlayersRepository playersRepository;

  const DeleteTrainsUseCase({
    required this.trainRepository,
    required this.playersRepository,
  });

  @override
  Future<void> call(TrainsListParams params) async {
    for (final train in params.trains) {
      await playersRepository.deleteAllPlayers(train.playersKey!);
    }
    return await trainRepository.deleteTrains(params.trains);
  }
}
