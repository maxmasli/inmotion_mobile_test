import 'package:inmotion_mobile_test/core/domain/usecases/usecase.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/players_repository.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/train_repository.dart';

class SaveTrainUseCase implements UseCase<void, TrainParams> {
  final TrainRepository trainRepository;
  final PlayersRepository playersRepository;

  const SaveTrainUseCase({
    required this.trainRepository,
    required this.playersRepository,
  });

  @override
  Future<void> call(TrainParams params) async {
    assert(params.train.playersKey != null, 'Players key is null');
    final train = params.train;
    await trainRepository.saveTrain(train);
    await playersRepository.savePlayers(train.playersKey!, train.players);
  }
}
