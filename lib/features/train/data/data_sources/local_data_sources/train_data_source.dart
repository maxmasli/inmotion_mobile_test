import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:inmotion_mobile_test/features/train/data/DTOs/train_dto.dart';

abstract interface class TrainDataSource {
  Future<void> saveTrain(TrainDTO train);
  Future<void> updateTrain(TrainDTO train);
  Future<List<TrainDTO>> getTrains();
  Future<void> deleteTrain(TrainDTO train);
  Future<void> deleteTrains(Iterable<TrainDTO> trains);
}

final class TrainDataSourceImpl implements TrainDataSource {
  @override
  Future<void> deleteTrain(TrainDTO train) async {
    log('Deleting train: ${train.uuid}', name: 'TrainDataSourceImpl');
    final box = await _openBox();
    await box.delete(train.uuid);
    await box.close();
  }

  @override
  Future<void> deleteTrains(Iterable<TrainDTO> trains) async {
    final box = await _openBox();
    for (final train in trains) {
      log('Deleting train ${train.uuid}', name: 'TrainDataSourceImpl');
      await box.delete(train.uuid);
    }
    await box.close();
  }

  @override
  Future<void> saveTrain(TrainDTO train) async {
    log('Save train: ${train.uuid}', name: 'TrainDataSourceImpl');
    final box = await _openBox();
    await box.put(train.uuid, train);
    await box.close();
  }

  @override
  Future<List<TrainDTO>> getTrains() async {
    log('Get trains', name: 'TrainDataSourceImpl');
    final box = await _openBox();
    final list = box.values.toList();
    await box.close();
    return list;
  }

  @override
  Future<void> updateTrain(TrainDTO train) async {
    log('Update train: ${train.uuid} ${train.trainName}', name: 'TrainDataSourceImpl');
    final box = await _openBox();
    await box.put(train.uuid, train);
    await box.close();
  }

  Future<Box<TrainDTO>> _openBox() async {
    const boxName = 'trains';
    return await Hive.openBox(boxName);
  }
}
