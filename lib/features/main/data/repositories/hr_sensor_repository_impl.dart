import 'package:inmotion_mobile_test/features/main/domain/entities/hr_sensor_entity.dart';
import 'package:inmotion_mobile_test/features/main/domain/repositories/hr_sensor_repository.dart';

class HrSensorRepositoryImpl implements HrSensorRepository {
  @override
  HrSensorEntity createSensor() {
    final hrSensor = HrSensorEntity()..init();
    return hrSensor;
  }
}

