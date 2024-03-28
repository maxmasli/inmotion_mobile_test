import 'package:inmotion_mobile_test/core/domain/usecases/usecase.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/train_repository.dart';

class DeleteTrainsUseCase implements UseCase<void, TrainsListParams> {

  final TrainRepository trainRepository;

  const DeleteTrainsUseCase({
    required this.trainRepository,
  });

  @override
  Future<void> call(TrainsListParams params) async {
    return trainRepository.deleteTrains(params.trains);
  }
}
