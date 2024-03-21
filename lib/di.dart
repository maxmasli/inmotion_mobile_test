import 'package:get_it/get_it.dart';
import 'package:inmotion_mobile_test/core/presentation/app_logs_controller.dart';
import 'package:inmotion_mobile_test/features/train/data/repositories/gps_sensor_repository_impl.dart';
import 'package:inmotion_mobile_test/features/train/data/repositories/hr_sensor_repository_impl.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/gps_sensor_repository.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/hr_sensor_repository.dart';

final getIt = GetIt.instance;

void setup() {
  final logController = AppLogsController();
  getIt.registerSingleton(logController);
}