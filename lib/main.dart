import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sistema_escalas_front/screens/home_screen.dart';
import 'package:sistema_escalas_front/screens/splash_screen.dart';

import 'config/app_config.dart';
import 'widgets/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppConfig.init();

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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('pt', 'BR'),
      ],
      navigatorObservers: [
        routeObserver
      ],
      home: const SplashScreen(),
    );
  }
}
