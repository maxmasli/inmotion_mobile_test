import 'package:inmotion_mobile_test/core/utils/settings.dart';

abstract class StatsCalculator {
  static List<double> getHrStats(List<int> hrList) {
    if (hrList.isEmpty) return <double>[1, 0, 0, 0, 0];

    final result = <double>[0, 0, 0, 0, 0];

    for (final hr in hrList) {
      if (hr > Settings.maximumIntensity) {
        result[4] += 1;
      } else if (hr > Settings.anaerobicMode) {
        result[3] += 1;
      } else if (hr > Settings.aerobicMode) {
        result[2] += 1;
      } else if (hr > Settings.lightLoad) {
        result[1] += 1;
      } else {
        result[0] += 1;
      }
    }

    return result.map((e) => e / hrList.length).toList();
  }
}