import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/router/app_router.dart';
import 'core/constants/theme_constants.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Windeath44 Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeConstants.getTheme(themeMode).copyWith(
        textTheme: GoogleFonts.interTextTheme(
          ThemeConstants.getTheme(themeMode).textTheme,
        ),
      ),
      routerConfig: router,
    );
  }
}
