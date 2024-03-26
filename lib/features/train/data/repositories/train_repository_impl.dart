import 'package:inmotion_mobile_test/features/train/data/DTOs/train_dto.dart';
import 'package:inmotion_mobile_test/features/train/data/data_sources/local_data_sources/train_data_source.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/train_repository.dart';

final class TrainRepositoryImpl implements TrainRepository {
  final TrainDataSource trainDataSource;

  const TrainRepositoryImpl({
    required this.trainDataSource,
  });

  @override
  Future<void> deleteTrain(TrainEntity train) async {
    return await trainDataSource.deleteTrain(TrainDTO.fromEntity(train));
  }

  @override
  Future<void> deleteTrains(Iterable<TrainEntity> trains) async {
    return await trainDataSource
        .deleteTrains(trains.map((t) => TrainDTO.fromEntity(t)));
  }

  @override
  Future<void> saveTrain(TrainEntity train) async {
    return await trainDataSource.saveTrain(TrainDTO.fromEntity(train));
  }

  @override
  Future<void> updateTrain(TrainEntity train) async {
    return await trainDataSource.updateTrain(TrainDTO.fromEntity(train));
  }

  @override
  Future<List<TrainEntity>> getTrains() async {
    return (await trainDataSource.getTrains())
        .map((t) => t.toEntity())
        .toList();
  }
}
