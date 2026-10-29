import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'views/auth/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spor Uygulaması',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const LoginView(),
    );
  }
}
