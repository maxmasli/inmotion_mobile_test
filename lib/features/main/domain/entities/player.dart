import 'package:inmotion_mobile_test/features/main/domain/entities/gps_sensor.dart';
import 'package:inmotion_mobile_test/features/main/domain/entities/hr_sensor.dart';

class Player {
  final String name;
  final int number;
  final List<PlayerError> errors;

  int distance;
  int steps;
  RunningType runningType;

  GpsSensor? gpsSensor;
  HrSensor? hrSensor;

  Player({
    required this.name,
    required this.number,
    this.errors = const [],
    this.distance = 0,
    this.steps = 0,
    this.runningType = RunningType.onFoot,
  });
}

enum PlayerError {
  hrError, stationError, gpsError, otherError
}

enum RunningType {
  onFoot, jogging, run, acceleration
}