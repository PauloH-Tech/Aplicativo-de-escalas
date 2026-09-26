import 'package:flutter/material.dart';
import 'package:sistema_escalas_front/models/usuario.dart';
import 'package:sistema_escalas_front/screens/admin_home_screen.dart';
import 'package:sistema_escalas_front/screens/login_screen.dart';
import 'package:sistema_escalas_front/screens/user_home_screen.dart';
import 'package:sistema_escalas_front/services/auth_service.dart';

class NavegacaoAuth {
  static Widget telaPorRole(Role role) => switch (role) {
    Role.admin => const AdminHomeScreen(),
    Role.user => const UserHomeScreen(),
  };

  static void irParaHome(BuildContext context, Usuario usuario) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => telaPorRole(usuario.role)),
      (_) => false,
    );
  }

  static Future<void> sair(BuildContext context) async {
    await AuthService.carregarSessao();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }
}
