import 'package:flutter/material.dart';

enum AppThemeMode {
  newYork,
  sanFrancisco,
  windeath44,
  light,
}

class ThemeConstants {
  // New York theme (Dark blue/black)
  static final newYorkTheme = ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF3B82F6),
      secondary: Color(0xFF60A5FA),
      surface: Color(0xFF050505),
      background: Color(0xFF050505),
      error: Color(0xFFEF4444),
    ),
    scaffoldBackgroundColor: const Color(0xFF050505),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF050505),
      elevation: 0,
    ),
  );

  // San Francisco theme (Orange/warm)
  static final sanFranciscoTheme = ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFF97316),
      secondary: Color(0xFFFB923C),
      surface: Color(0xFF0A0A0A),
      background: Color(0xFF0A0A0A),
      error: Color(0xFFEF4444),
    ),
    scaffoldBackgroundColor: const Color(0xFF0A0A0A),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0A0A0A),
      elevation: 0,
    ),
  );

  // Windeath44 theme (Purple/violet)
  static final windeath44Theme = ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFA855F7),
      secondary: Color(0xFFC084FC),
      surface: Color(0xFF0F0F0F),
      background: Color(0xFF0F0F0F),
      error: Color(0xFFEF4444),
    ),
    scaffoldBackgroundColor: const Color(0xFF0F0F0F),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0F0F0F),
      elevation: 0,
    ),
  );

  // Light theme
  static final lightTheme = ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF3B82F6),
      secondary: Color(0xFF60A5FA),
      surface: Color(0xFFFFFFFF),
      background: Color(0xFFFAFAFA),
      error: Color(0xFFEF4444),
    ),
    scaffoldBackgroundColor: const Color(0xFFFAFAFA),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFFFFF),
      elevation: 0,
    ),
  );

  static ThemeData getTheme(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.newYork:
        return newYorkTheme;
      case AppThemeMode.sanFrancisco:
        return sanFranciscoTheme;
      case AppThemeMode.windeath44:
        return windeath44Theme;
      case AppThemeMode.light:
        return lightTheme;
    }
  }

  static String getThemeName(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.newYork:
        return 'NYC';
      case AppThemeMode.sanFrancisco:
        return 'SF';
      case AppThemeMode.windeath44:
        return 'W44';
      case AppThemeMode.light:
        return 'LIGHT';
    }
  }

  static Color getThemeIndicatorColor(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.newYork:
        return const Color(0xFF3B82F6);
      case AppThemeMode.sanFrancisco:
        return const Color(0xFFF97316);
      case AppThemeMode.windeath44:
        return const Color(0xFFA855F7);
      case AppThemeMode.light:
        return const Color(0xFF1F2937);
    }
  }
}
