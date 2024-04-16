import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/colors.dart';
import 'package:inmotion_mobile_test/core/utils/settings.dart';
import 'package:path_provider/path_provider.dart';

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

Future<Directory> getWorkingDirectory() async {
  if (Platform.isAndroid) {
    return await Directory('/storage/emulated/0/Documents/Movecross').create();
  }

  final docDir = await getApplicationDocumentsDirectory();

  return Directory('${docDir.path}/Movecross');
}
