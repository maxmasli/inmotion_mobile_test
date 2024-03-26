import 'package:inmotion_mobile_test/core/utils/decoder/tag_data.dart';

class MeasureEntity {
  // TODO create UUID maybe

  MeasureEntity({
    this.time,
    this.hr,
    this.latitude,
    this.longitude,
    this.speed,
    this.distance,
    this.steps,
    this.activity,
    this.imu,
  });

  DateTime? time;
  int? hr;

  double? latitude, longitude;

  double? speed;
  double? distance;

  int? steps;
  int? activity;

  List<IMU>? imu;

  @override
  String toString() {
    return [
      if (time != null) "Time $time",
      if (hr != null) "hr $hr",
      if (latitude != null && longitude != null) "loc: ($latitude, $longitude)",
      if (speed != null) "speed: ${speed!.toStringAsFixed(3)}",
      if (distance != null) "distance: ${distance!.toStringAsFixed(0)}",
      if (steps != null) "steps: $steps",
      if (activity != null) "activity $activity",
      if (imu != null) "imu: $imu"
    ].join(", ");
  }

// DateTime dt = DateTime();
}
