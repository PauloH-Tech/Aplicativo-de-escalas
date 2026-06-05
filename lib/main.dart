import 'package:flutter/material.dart';
import 'package:sistema_escalas_front/screens/home_screen.dart';
import 'widgets/app_theme.dart';

void main() {
  runApp(const EscalaExtraApp());
}

class EscalaExtraApp extends StatelessWidget {
  const EscalaExtraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escalas Extras',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
