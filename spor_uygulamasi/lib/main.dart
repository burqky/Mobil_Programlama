import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/auth_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/catalog_screen.dart';

void main() {
  runApp(const SporUygulamasiApp());
}

class SporUygulamasiApp extends StatelessWidget {
  const SporUygulamasiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spor Takip',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthScreen(),
        '/home': (context) => const MainNavigationScreen(),
        '/catalog': (context) => const CatalogScreen(),
      },
    );
  }
}
