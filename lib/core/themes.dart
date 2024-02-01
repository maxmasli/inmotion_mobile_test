import 'package:flutter/material.dart';

ThemeData createLightTheme() {
  return ThemeData(
    textTheme: _baseTextTheme(false)
  );
}

TextTheme _baseTextTheme(bool isDark) {
  if (isDark) {
    return const TextTheme();
  } else {
    return const TextTheme();
  }
}