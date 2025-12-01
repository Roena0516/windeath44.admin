import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/theme_constants.dart';

const String _themeKey = 'app_theme_mode';

// Theme notifier
class ThemeNotifier extends StateNotifier<AppThemeMode> {
  ThemeNotifier() : super(AppThemeMode.newYork) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 0;
    state = AppThemeMode.values[themeIndex];
  }

  Future<void> setTheme(AppThemeMode theme) async {
    state = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, theme.index);
  }

  void toggleTheme() {
    final nextTheme = switch (state) {
      AppThemeMode.newYork => AppThemeMode.sanFrancisco,
      AppThemeMode.sanFrancisco => AppThemeMode.windeath44,
      AppThemeMode.windeath44 => AppThemeMode.light,
      AppThemeMode.light => AppThemeMode.newYork,
    };
    setTheme(nextTheme);
  }
}

// Theme provider
final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>((ref) {
  return ThemeNotifier();
});
