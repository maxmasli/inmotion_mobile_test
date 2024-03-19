import 'package:vector_math/vector_math_64.dart';

class IMU {
  Vector4? q;
  Vector3? a;
  Vector3? g;
  Vector3? m;

  @override
  String toString() {
    return "{${[
      if (q != null) "q: (${q!.x.toStringAsFixed(3)}, ${q!.y.toStringAsFixed(3)}, ${q!.z.toStringAsFixed(3)}, ${q!.w.toStringAsFixed(3)})",
      if (a != null) "a: (${a!.x.toStringAsFixed(3)}, ${a!.y.toStringAsFixed(3)}, ${a!.z.toStringAsFixed(3)})",
      if (g != null) "g: (${g!.x.toStringAsFixed(3)}, ${g!.y.toStringAsFixed(3)}, ${g!.z.toStringAsFixed(3)})",
      if (m != null) "m: (${m!.x.toStringAsFixed(3)}, ${m!.y.toStringAsFixed(3)}, ${m!.z.toStringAsFixed(3)})"
    ].join(', ')}}";
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

  static final int _gnssEn = 0x01;
  static final int _gnssOk = 0x02;
  static final int _lpsEn = 0x04;
  static final int _lpsOk = 0x08;
  static final int _hrOk = 0x10;
  static final int _recording = 0x20;

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

