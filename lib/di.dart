import 'package:get_it/get_it.dart';
import 'package:inmotion_mobile_test/core/presentation/app_logs_controller.dart';

final getIt = GetIt.instance;

void setup() {
  final logController = AppLogsController();
  getIt.registerSingleton(logController);
}