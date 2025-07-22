import 'package:uuid/uuid.dart';

class SplitEntity {
  String name;
  final String uuid;
  Duration? startFragment;
  Duration? endFragment;

  SplitEntity({
    required this.name,
    required this.uuid,
    this.startFragment,
    this.endFragment,
  });

  factory SplitEntity.empty() {
    return SplitEntity(name: "", uuid: const Uuid().v4());
  }

  set setName(String value) => name = value;

  void tryParseStartFragment(String value) {
    startFragment = _parseTimeString(value);
  }

  void tryParseEndFragment(String value) {
    endFragment = _parseTimeString(value);
  }

  void tryParseTotalFragment(String value) {
    final total = _parseTimeString(value);
    if (total == null) return;
    if (startFragment != null) {
      endFragment = startFragment! + total;
    } else if (endFragment != null) {
      startFragment = endFragment! - total;
    }
  }

  Duration? _parseTimeString(String time) {
    try {
      List<String> parts = time.split(':');

      if (parts.length == 2) {
        // Формат mm:ss
        if (parts[1].length != 2) return null;
        int minutes = int.parse(parts[0]);
        int seconds = int.parse(parts[1]);
        return Duration(minutes: minutes, seconds: seconds);
      } else if (parts.length == 3) {
        // Формат hh:mm:ss
        if (parts[2].length != 2) return null;
        int hours = int.parse(parts[0]);
        int minutes = int.parse(parts[1]);
        int seconds = int.parse(parts[2]);
        return Duration(hours: hours, minutes: minutes, seconds: seconds);
      } else {
        return null;
      }
    } on Exception {
      return null;
    }
  }

  bool correctFragments(Duration trainTime) {
    if (startFragment == null || endFragment == null) return false;
    if (startFragment! > trainTime || endFragment! > trainTime) return false;
    return startFragment! < endFragment!;
  }
}

extension Format on Duration {
  String format() {
    int hours = inHours;
    int minutes = inMinutes % 60;
    int seconds = inSeconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
}