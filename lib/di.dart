import 'package:get_it/get_it.dart';
import 'package:inmotion_mobile_test/core/presentation/app_logs_controller.dart';
import 'package:inmotion_mobile_test/features/train/data/data_sources/local_data_sources/players_data_source.dart';
import 'package:inmotion_mobile_test/features/train/data/data_sources/local_data_sources/sensor_players_data_source.dart';
import 'package:inmotion_mobile_test/features/train/data/data_sources/local_data_sources/train_data_source.dart';
import 'package:inmotion_mobile_test/features/train/data/repositories/players_repository_impl.dart';
import 'package:inmotion_mobile_test/features/train/data/repositories/sensor_players_repository_impl.dart';
import 'package:inmotion_mobile_test/features/train/data/repositories/train_repository_impl.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/players_repository.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/sensor_players_repository.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/train_repository.dart';
import 'package:inmotion_mobile_test/features/train/domain/usecases/get_players_sensor_usecase.dart';
import 'package:inmotion_mobile_test/features/train/domain/usecases/get_trains_usecase.dart';
import 'package:inmotion_mobile_test/features/train/domain/usecases/save_player_sencor_usecase.dart';
import 'package:inmotion_mobile_test/features/train/domain/usecases/save_train_usecase.dart';

final getIt = GetIt.instance;

void setup() {
  final logController = AppLogsController();
  getIt.registerSingleton(logController);

  // Data sources
  getIt.registerLazySingleton<TrainDataSource>(() => TrainDataSourceImpl());
  getIt.registerLazySingleton<PlayersDataSource>(() => PlayersDataSourceImpl());
  getIt.registerLazySingleton<SensorPlayerDataSource>(
      () => SensorPlayerDataSourceImpl());

  // Repositories
  getIt.registerLazySingleton<TrainRepository>(
      () => TrainRepositoryImpl(trainDataSource: getIt<TrainDataSource>()));
  getIt.registerLazySingleton<PlayersRepository>(() =>
      PlayersRepositoryImpl(playersDataSource: getIt<PlayersDataSource>()));
  getIt.registerLazySingleton<SensorPlayersRepository>(() =>
      SensorPlayersRepositoryImpl(
          sensorPlayerDataSource: getIt<SensorPlayerDataSource>()));

  // Use cases
  getIt.registerFactory<SaveTrainUseCase>(() => SaveTrainUseCase(
      trainRepository: getIt<TrainRepository>(),
      playersRepository: getIt<PlayersRepository>()));

  getIt.registerFactory<GetTrainsUseCase>(
      () => GetTrainsUseCase(trainRepository: getIt<TrainRepository>()));

  getIt.registerFactory(() => SavePlayerSensorUseCase(
      sensorPlayersRepository: getIt<SensorPlayersRepository>()));

  getIt.registerFactory(() => GetPlayersSensorUseCase(
      sensorPlayersRepository: getIt<SensorPlayersRepository>()));
}
