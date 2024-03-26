import 'package:inmotion_mobile_test/core/domain/usecases/usecase.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/train_repository.dart';

class GetTrainsUseCase implements UseCase<List<TrainEntity>, EmptyParams> {
  final TrainRepository trainRepository;

  const GetTrainsUseCase({
    required this.trainRepository,
  });

  @override
  Future<List<TrainEntity>> call([EmptyParams? params]) async {
    return await trainRepository.getTrains();
  }
}
