import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/colors.dart';

ThemeData createLightTheme() {
  return ThemeData(
    textTheme: _baseTextTheme(false),
    scaffoldBackgroundColor: AppColors.gray239,
    colorScheme: ThemeData().colorScheme.copyWith(
          primaryContainer: Colors.white,
          secondaryContainer: AppColors.lightGreen,
          tertiaryContainer: AppColors.green,
        ),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(
        color: AppColors.lightGreen2,
        fontFamily: 'Roboto',
        fontSize: 17,
      ),
      enabledBorder: InputBorder.none,
      disabledBorder: OutlineInputBorder(),
      errorBorder: OutlineInputBorder(),
      focusedErrorBorder: OutlineInputBorder(),
      focusedBorder: InputBorder.none,
    ),

    textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.green,
        selectionHandleColor: AppColors.green,
        selectionColor: AppColors.green.withOpacity(0.4)
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.lightGreen,
      thickness: 0.8,
      space: 1,
    )
  );
}

TextTheme _baseTextTheme(bool isDark) {
  if (isDark) {
    return const TextTheme();
  } else {
    return const TextTheme(
      titleMedium: TextStyle(
        fontFamily: 'RobotoMedium',
        fontSize: 17,
        color: AppColors.green,
      ),
      titleLarge: TextStyle(
        fontFamily: 'RobotoMedium',
        fontSize: 28,
        color: AppColors.green,
      ),
      displayLarge: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 17,
        color: AppColors.gray186,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 17,
        color: Colors.black,
      ),
      labelLarge: TextStyle(
        fontFamily: 'RobotoMedium',
        fontSize: 20,
        color: Colors.white,
      ),
    );
  }
}
