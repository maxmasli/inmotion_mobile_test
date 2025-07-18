import 'package:inmotion_mobile_test/core/utils/decoder/inmotion_tag_data.dart';

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

  /* Пульс в уд/мин */
  int? hr;

  /* Широта и долгота в градусах */
  double? latitude, longitude;

  /* Скорость в м/с */
  double? speed;

  /* Пройденное расстояние в метрах */
  double? distance;

  /* Количество шагов */
  int? steps;

  /* Активность в псевдоединицах 0-255 */
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
}
