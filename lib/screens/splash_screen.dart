import 'dart:async';

import 'package:flutter/material.dart';
import 'package:escalas_extras/models/usuario.dart';
import 'package:escalas_extras/screens/login_screen.dart';
import 'package:escalas_extras/services/auth_service.dart';
import 'package:escalas_extras/utils/navegacao_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    final resultados = await Future.wait([
      Future.delayed(const Duration(seconds: 3)),
      AuthService.carregarSessao(),
    ]);
    final usuario = resultados[1] as Usuario?;

    if (!mounted) return;
    if (usuario != null) {
      NavegacaoAuth.irParaHome(context, usuario);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo_policia_militar.png', height: 150),
              const SizedBox(height: 16),
              Text(
                'Escalas Extras\nPolícia Militar Do Paraná',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
