import 'package:inmotion_mobile_test/features/train/domain/entities/gps_sensor_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/gps_sensor_repository.dart';

class GpsSensorRepositoryImpl implements GpsSensorRepository {
  @override
  GpsSensorEntity createSensor() {
    final hrSensor = GpsSensorEntity()..init();
    return hrSensor;
  }
}