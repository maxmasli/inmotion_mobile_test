import 'package:inmotion_mobile_test/core/utils/settings.dart';
import 'package:inmotion_mobile_test/features/main/domain/entities/hr_measure_entity.dart';

abstract class StatsCalculator {
  static List<double> getHrStats(List<HrMeasureEntity> meas) {
    if (meas.isEmpty) return <double>[1, 0, 0, 0, 0];

    final result = <double>[0, 0, 0, 0, 0];

    for (final meas in meas) {
      if (meas.hr > Settings.maximumIntensity) {
        result[4] += 1;
      } else if (meas.hr > Settings.anaerobicMode) {
        result[3] += 1;
      } else if (meas.hr > Settings.aerobicMode) {
        result[2] += 1;
      } else if (meas.hr > Settings.lightLoad) {
        result[1] += 1;
      } else {
        result[0] += 1;
      }
    }

    return result.map((e) => e / meas.length).toList();
  }
}