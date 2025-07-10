import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColors.kPrimaryColor,
      onPrimary: AppColors.kWhite,
    ),
    canvasColor: AppColors.kWhite,
    scaffoldBackgroundColor: AppColors.kWhite,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.kPrimaryColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: AppColors.kBlueLight,
      ),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.kPrimaryColor,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.kWhite,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.kWhite,
      selectedItemColor: AppColors.kPrimaryColor,
      unselectedItemColor: AppColors.kPrimaryColor.withValues(alpha: 153), // 0.6
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.kPrimaryColor,
      foregroundColor: AppColors.kWhite,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.kWhite,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.kWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
    textTheme: const TextTheme(),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.kDarkBlue,
      onPrimary: AppColors.kWhite,
      surface: AppColors.kDarkBlueLight,
      onSurface: AppColors.kWhite,
      onSecondary: AppColors.kDarkBlue,
    ),
    scaffoldBackgroundColor: const Color.fromARGB(255, 21, 66, 104),
    canvasColor: AppColors.kDarkBlueLight,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: AppColors.kBlueLight,
        foregroundColor: AppColors.kWhite,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.kWhite,
      ),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.kWhite,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.kDarkBlue,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.kDarkBlueLight,
      selectedItemColor: AppColors.kWhite,
      unselectedItemColor: AppColors.kWhite.withValues(alpha: 153), // 0.6
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.kPrimaryColor,
      foregroundColor: AppColors.kWhite,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.kDarkBlue,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.kDarkBlueLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
    textTheme: const TextTheme(),
  );
}
