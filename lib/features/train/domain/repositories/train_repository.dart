import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';

abstract interface class TrainRepository {
  Future<void> saveTrain(TrainEntity train);
  Future<void> updateTrain(TrainEntity train);
  Future<List<TrainEntity>> getTrains();
  Future<void> deleteTrain(TrainEntity train);
  Future<void> deleteTrains(Iterable<TrainEntity> trains);
}