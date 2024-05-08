import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/colors.dart';
import 'package:inmotion_mobile_test/core/utils/settings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

const minTabletSize = 1000;

Color getColorByPulse(int pulse) {
  if (pulse >= Settings.maximumIntensity) {
    return AppColors.red;
  } else if (pulse >= Settings.anaerobicMode) {
    return AppColors.orange;
  } else if (pulse >= Settings.aerobicMode) {
    return AppColors.green;
  } else if (pulse >= Settings.lightLoad) {
    return AppColors.blue;
  } else {
    return AppColors.gray134;
  }
}

// TODO заменить с импользованием intl
String getRunBySpeed(double speed, BuildContext context) {
  if (speed >= 8) {
    return "Ускорение";
  } else if (speed >= 5) {
    return "Бегом";
  } else if (speed >= 2) {
    return "Трусцой";
  } else {
    return "Пешком";
  }
}

Color getColorBySpeed(int speed) {
  if (speed >= 8) {
    return AppColors.red;
  } else if (speed >= 5) {
    return AppColors.orange;
  } else if (speed >= 2) {
    return AppColors.green;
  } else {
    return AppColors.blue;
  }
}

String getPointPathBySpeed(int speed) {
  if (speed >= 8) {
    return 'assets/icons/red_point.png';
  } else if (speed >= 5) {
    return 'assets/icons/orange_point.png';
  } else if (speed >= 2) {
    return 'assets/icons/green_point.png';
  } else {
    return 'assets/icons/blue_point.png';
  }
}

Future<Directory> getWorkingDirectory() async {
  if (Platform.isAndroid) {
    return await Directory('/storage/emulated/0/Documents/Movecross').create();
  }

  final docDir = await getApplicationDocumentsDirectory();

  return Directory('${docDir.path}/Movecross');
}

Future<void> shareFile(String path) async {
  final xfile = XFile(path);
  await Share.shareXFiles([xfile]);
}

extension SameDay on DateTime {
  bool isSameDay(DateTime dateTime) =>
      year == dateTime.year && month == dateTime.month && day == dateTime.day;
}
