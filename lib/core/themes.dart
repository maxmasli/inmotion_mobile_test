import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/core/colors.dart';

ThemeData createLightTheme() {
  return ThemeData(
    textTheme: _baseTextTheme(false),
    primaryColor: AppColors.lightGreen,
    scaffoldBackgroundColor: AppColors.gray239,
    colorScheme: ThemeData().colorScheme.copyWith(
          primaryContainer: Colors.white,
          secondaryContainer: AppColors.lightGreen,
          tertiaryContainer: AppColors.green,
          error: AppColors.red,
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
        selectionColor: AppColors.green.withOpacity(0.4)),
    dividerTheme: const DividerThemeData(
      color: AppColors.lightGreen,
      thickness: 0.8,
      space: 1,
    ),
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.lightGreen),
    indicatorColor: AppColors.lightGreen,
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: AppColors.green),
    switchTheme: SwitchThemeData(
      overlayColor: const MaterialStatePropertyAll(AppColors.green),
      thumbColor: const MaterialStatePropertyAll(Colors.white),
      trackColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.green;
        } else {
          return AppColors.gray186;
        }
      }),
      trackOutlineColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.green;
        } else {
          return AppColors.gray186;
        }
      }),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: MaterialStatePropertyAll(
          AppColors.lightGreen.withOpacity(0.1),
        ),
        visualDensity: VisualDensity.compact
      ),
    ),
  );
}

TextTheme _baseTextTheme(bool isDark) {
  if (isDark) {
    return const TextTheme();
  } else {
    return const TextTheme(
      titleSmall: TextStyle(
        fontFamily: 'RobotoMedium',
        fontSize: 14,
        color: AppColors.lightGreen,
      ),
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
      //------------------------
      displaySmall: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 12,
        color: AppColors.gray134,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,
        color: AppColors.gray134,
      ),
      displayLarge: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 17,
        color: AppColors.gray186,
      ),
      //------------------------
      labelSmall: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,
        color: Colors.white,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 17,
        color: Colors.black,
      ),
      labelLarge: TextStyle(
        fontFamily: 'RobotoMedium',
        fontSize: 22,
        color: Colors.white,
      ),
      //------------------------
      headlineSmall: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 12,
        color: Colors.black,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 28,
        color: AppColors.gray73,
      ),
      //-------------------------
      bodyMedium: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 17,
        color: AppColors.gray134,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
