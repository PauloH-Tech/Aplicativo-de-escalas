import 'package:flutter/material.dart';
import 'package:escalas_extras/models/usuario.dart';
import 'package:escalas_extras/screens/admin_home_screen.dart';
import 'package:escalas_extras/screens/login_screen.dart';
import 'package:escalas_extras/screens/user_home_screen.dart';
import 'package:escalas_extras/services/auth_service.dart';

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
    await AuthService.logout();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }
}
