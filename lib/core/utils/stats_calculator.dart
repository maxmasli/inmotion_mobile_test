import 'dart:developer';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:inmotion_mobile_test/core/utils/settings.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';

abstract class StatsCalculator {
  static double calculatedPulseAtMaximum(PlayerEntity player) => 200;

  static double restingPulse() => 60;

  static int calculatedVo2max(
    PlayerEntity player, [
    Duration? start,
    Duration? end,
  ]) =>
      ((calculateMaxPulse(player, start, end) / restingPulse()) * 15.3).round();

  static int calculatedIntensity(
    PlayerEntity player, [
    Duration? start,
    Duration? end,
  ]) {
    int result = (100 *
            (calculateAvgPulse(player, start, end) - restingPulse()) /
            (calculatedPulseAtMaximum(player) - restingPulse()))
        .clamp(0, 100)
        .ceil();

    return result;
  }

  static int calculateAvgPulse(
    PlayerEntity player, [
    Duration? start,
    Duration? end,
  ]) {
    if (player.measures.isEmpty) return 0;
    var meas = player.measures;
    if (start != null && end != null) {
      final startDateTime = player.measures.first.time!.add(start);
      final endDateTime = player.measures.first.time!.add(end);
      meas = player.measures
          .where((m) =>
              m.time!.isAfter(startDateTime) && m.time!.isBefore(endDateTime))
          .toList();
    }

    final list =
        meas.where((e) => e.hr != null && e.hr != 0).map((e) => e.hr ?? 0);

    return list.isEmpty ? 0 : list.average.ceil();
  }

  static int calculateMaxPulse(
    PlayerEntity player, [
    Duration? start,
    Duration? end,
  ]) {
    if (player.measures.isEmpty) return 0;
    var meas = player.measures;
    if (start != null && end != null) {
      final startDateTime = player.measures.first.time!.add(start);
      final endDateTime = player.measures.first.time!.add(end);
      meas = player.measures
          .where((m) =>
              m.time!.isAfter(startDateTime) && m.time!.isBefore(endDateTime))
          .toList();
    }
    return meas.map((e) => e.hr ?? 0).maxOrNull ?? 0;
  }

  static int calculateMinPulse(
    PlayerEntity player, [
    Duration? start,
    Duration? end,
  ]) {
    if (player.measures.isEmpty) return 0;
    var meas = player.measures;
    if (start != null && end != null) {
      final startDateTime = player.measures.first.time!.add(start);
      final endDateTime = player.measures.first.time!.add(end);
      meas = player.measures
          .where((m) =>
              m.time!.isAfter(startDateTime) && m.time!.isBefore(endDateTime))
          .toList();
    }
    return meas.map((e) => e.hr ?? 0).minOrNull ?? 0;
  }

  static int getCalories(
    PlayerEntity player, [
    Duration? start,
    Duration? end,
  ]) {
    if (player.measures.isEmpty) return 0;
    var meas = player.measures;
    if (start != null && end != null) {
      final startDateTime = player.measures.first.time!.add(start);
      final endDateTime = player.measures.first.time!.add(end);
      meas = player.measures
          .where((m) =>
              m.time!.isAfter(startDateTime) && m.time!.isBefore(endDateTime))
          .toList();
    }
    if (meas.last.time == null || meas.first.time == null) return 0;
    try {
      return (meas.last.time!.difference(meas.first.time!).inMinutes *
              (0.634 * calculateAvgPulse(player, start, end) +
                  0.404 * calculatedVo2max(player, start, end) +
                  0.394 * 75 + // person.weight = 75
                  0.271 * 25 - // person.age = 25
                  95.7735) /
              4.184)
          .round();
    } catch (e) {
      log('Error calculating calories: $e', name: 'StatsCalculator', error: e);
      return 0;
    }
  }

  static int getFats(
    PlayerEntity player, [
    Duration? start,
    Duration? end,
  ]) {
    final vo2maxtr = (calculateMaxPulse(player, start, end) /
            calculateMinPulse(player, start, end).toDouble()) *
        15.3;
    final vo2maxPercent =
        (vo2maxtr / calculatedVo2max(player, start, end)) * 100;
    if (vo2maxPercent >= 41 && vo2maxPercent < 48) {
      return (-0.0497 * (vo2maxPercent * vo2maxPercent) +
              3.8528 * vo2maxPercent -
              23.55)
          .round();
    } else if (vo2maxPercent >= 48 && vo2maxPercent <= 97) {
      return (-1.2746 * vo2maxPercent + 108.24).round();
    } else {
      return 0;
    }
  }

  static int getProteins(
    PlayerEntity player, [
    Duration? start,
    Duration? end,
  ]) {
    final vo2maxtr = (calculateMaxPulse(player, start, end) /
            calculateMinPulse(player, start, end).toDouble()) *
        15.3;
    final vo2maxPercent =
        (vo2maxtr / calculatedVo2max(player, start, end)) * 100;
    if (vo2maxPercent >= 41 && vo2maxPercent < 48) {
      return (0.0497 * (vo2maxPercent * vo2maxPercent) -
              3.8528 * vo2maxPercent +
              123.55)
          .round();
    } else if (vo2maxPercent >= 48 && vo2maxPercent <= 97) {
      return (1.2746 * vo2maxPercent - 8.24).round();
    } else {
      return 0;
    }
  }

  static int getTrimp(
    PlayerEntity player, [
    Duration? start,
    Duration? end,
  ]) {
    if (player.measures.isEmpty) return 0;
    var meas = player.measures;
    if (start != null && end != null) {
      final startDateTime = player.measures.first.time!.add(start);
      final endDateTime = player.measures.first.time!.add(end);
      meas = player.measures
          .where((m) =>
              m.time!.isAfter(startDateTime) && m.time!.isBefore(endDateTime))
          .toList();
    }
    if (meas.last.time == null || meas.first.time == null) return 0;

    final reserve = (calculateAvgPulse(player) - restingPulse()) /
        (calculatedPulseAtMaximum(player) - restingPulse());
    const b = 1.92; // : 1.67; По дефолту пол мужской

    try {
      return (meas.last.time!.difference(meas.first.time!).inMinutes * reserve +
              math.exp(reserve * b))
          .round();
    } catch (e) {
      log('Error in getTrimp calculation: $e', name: 'StatsCalculator');
      return 0;
    }
  }

  static double getTrimpPerMinute(PlayerEntity player) {
    // TODO значение 0, потому что [m.time] в другой часовой зоне
    final lastMinuteValues = player.measures
        .where((m) =>
            m.hr != null &&
            m.time != null &&
            DateTime.now().difference(m.time!).inSeconds <= 60)
        .toList();
    if (lastMinuteValues.isEmpty) return 0;

    double avg = 0;
    for (var m in lastMinuteValues) {
      avg += m.hr!;
    }
    avg /= lastMinuteValues.length;

    final reserve = (avg - restingPulse()) /
        (calculatedPulseAtMaximum(player) - restingPulse());
    //final b = person.gender == 0 ? 1.92 : 1.67;
    final b = 1.92;

    return (1 * reserve + math.exp(reserve * b));
  }

  static List<double> getHrStats(
    PlayerEntity player, [
    Duration? start,
    Duration? end,
  ]) {
    if (player.measures.isEmpty) return [0, 0, 0, 0, 0];
    var meas = player.measures;
    if (start != null && end != null) {
      final startDateTime = player.measures.first.time!.add(start);
      final endDateTime = player.measures.first.time!.add(end);
      meas = player.measures
          .where((m) =>
              m.time!.isAfter(startDateTime) && m.time!.isBefore(endDateTime))
          .toList();
    }
    final hrList = meas.map((m) => m.hr).where((hr) => hr != null).toList();
    if (hrList.isEmpty) return <double>[1, 0, 0, 0, 0];

    final result = <double>[0, 0, 0, 0, 0];

    for (final hr in hrList) {
      if (hr! > Settings.maximumIntensity) {
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

  static double avgSpeedKph(
    PlayerEntity player, [
    Duration? start,
    Duration? end,
  ]) {
    var meas = player.measures;
    if (start != null && end != null) {
      final startDateTime = player.measures.first.time!.add(start);
      final endDateTime = player.measures.first.time!.add(end);
      meas = player.measures
          .where((m) =>
              m.time!.isAfter(startDateTime) && m.time!.isBefore(endDateTime))
          .toList();
    }
    final list =
        meas.where((m) => m.speed != null).map((m) => m.speed! * 3600 / 1000);
    if (list.isEmpty) return 0;
    return list.average;
  }

  static double maxSpeedKph(
    PlayerEntity player, [
    Duration? start,
    Duration? end,
  ]) {
    var meas = player.measures;
    if (start != null && end != null) {
      final startDateTime = player.measures.first.time!.add(start);
      final endDateTime = player.measures.first.time!.add(end);
      meas = player.measures
          .where((m) =>
              m.time!.isAfter(startDateTime) && m.time!.isBefore(endDateTime))
          .toList();
    }
    return meas.map((m) => m.speed ?? 0 * 3600 / 1000).maxOrNull ?? 0;
  }

  static double getDistance(PlayerEntity player, [Duration? start, Duration? end]) {
    if (start == null || end == null) {
      return player.measures.lastOrNull?.distance ?? 0;
    }

    final startDateTime = player.measures.first.time!.add(start);
    final endDateTime = player.measures.first.time!.add(end);
    final meas = player.measures
        .where((m) =>
            m.time!.isAfter(startDateTime) && m.time!.isBefore(endDateTime))
        .toList();

    if (meas.isEmpty) return 0;

    final startDistance = meas.first.distance!;
    final endDistance = meas.last.distance!;

    return endDistance - startDistance;
  }
}
