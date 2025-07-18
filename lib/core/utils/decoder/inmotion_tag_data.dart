import 'package:vector_math/vector_math.dart';

class IMU {

  final Vector4? q;
  final Vector3? g;
  final Vector3? m;
  final Vector3? a;

  IMU({
    this.q,
    this.g,
    this.m,
    this.a
  });

  @override
  String toString() {
    return "{${[
      if (q != null) "q: (${q!.x.toStringAsFixed(3)}, ${q!.y.toStringAsFixed(3)}, ${q!.z.toStringAsFixed(3)}, ${q!.w.toStringAsFixed(3)})",
      if (a != null) "a: (${a!.x.toStringAsFixed(3)}, ${a!.y.toStringAsFixed(3)}, ${a!.z.toStringAsFixed(3)})",
      if (g != null) "g: (${g!.x.toStringAsFixed(3)}, ${g!.y.toStringAsFixed(3)}, ${g!.z.toStringAsFixed(3)})",
      if (m != null) "m: (${m!.x.toStringAsFixed(3)}, ${m!.y.toStringAsFixed(3)}, ${m!.z.toStringAsFixed(3)})"
    ].join(', ')}}";
  }

  String toCsvRow() {
    return [
      q!.x.toStringAsFixed(3), q!.y.toStringAsFixed(3), q!.z.toStringAsFixed(3), q!.w.toStringAsFixed(3),
      a!.x.toStringAsFixed(3), a!.y.toStringAsFixed(3), a!.z.toStringAsFixed(3)
    ].join(';');
  }
}

class InmotionTagData {

  InmotionTagData(
    {this.time,
    this.hr,
    this.lat,
    this.lon,
    this.alt,
    this.speed,
    this.distance,
    this.activity,
    this.steps,
    this.imu}
  );

  final DateTime? time;
  final int? hr;

  final double? lat, lon, alt;

  final double? speed;
  final int? distance;
  
  final int? steps;
  final int? activity;

  final IMU? imu;

  @override
  String toString() {
    return [
      "Time $time",
      if (hr != null)       "hr $hr",
      "loc: ($lat, $lon)",
      "alt: $alt",
      if (speed != null) "speed: ${speed!.toStringAsFixed(3)}",
      if (distance != null) "distance: ${distance!.toStringAsFixed(0)}",
      if (steps != null)    "steps: $steps",
      if (activity != null) "activity $activity",
      "imu: $imu"
    ].join(", ");
  }

  String toCSVRow() {
    return "$time;$hr;$lat;$lon;$alt;$speed;$distance;${imu?.toCsvRow()}";
  }
}

class InmotionTagMeta {
  int increment;
  int label;
  int charge;
  int memoryUsage;
  int status;

  InmotionTagMeta(
    this.increment, 
    this.label, 
    this.charge, 
    this.memoryUsage, 
    this.status
  );

  bool get gnnsEn =>  _checkFlag(status, _gnssEn);
  bool get gnssOk =>  _checkFlag(status, _gnssOk);
  bool get lpsEn =>   _checkFlag(status, _lpsEn);
  bool get lpsOk =>   _checkFlag(status, _lpsOk);
  bool get hrOk =>    _checkFlag(status, _hrOk);
  bool get recording => _checkFlag(status, _recording);
  
  static const int _gnssEn = 0x01;
  static const int _gnssOk = 0x02;
  static const int _lpsEn = 0x04;
  static const int _lpsOk = 0x08;
  static const int _hrOk = 0x10;
  static const int _recording = 0x20;

  static bool _checkFlag(value, flag) => value & flag != 0;

  @override
  String toString() {
    return [
      "inc: $increment", 
      "label: $label", 
      "charge: $charge", 
      "memory: $memoryUsage",
      "GNSS: ${gnnsEn ? gnssOk ? "Ok" : "Bad" : "Dis"}",
      "LPS: ${lpsEn ? lpsOk ? "Ok" : "Bad" : "Dis"}",
      "HR: ${hrOk ? "Ok" : "Fail"}",
      "writing: ${recording ? "yes" : "no"}"
    ].join(", ");
  }
}

