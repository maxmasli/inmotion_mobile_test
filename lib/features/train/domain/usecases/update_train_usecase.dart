import 'package:inmotion_mobile_test/core/domain/usecases/usecase.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/train_repository.dart';

class UpdateTrainUseCase implements UseCase<void, TrainParams> {

  final TrainRepository trainRepository;

  const UpdateTrainUseCase({
    required this.trainRepository,
  });

  @override
  Future<void> call(TrainParams params) async {
    return await trainRepository.updateTrain(params.train);
  }
}
