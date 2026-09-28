import 'package:flutter/material.dart';
import 'package:sistema_escalas_front/screens/login_screen.dart';
import 'package:sistema_escalas_front/services/auth_service.dart';
import 'package:sistema_escalas_front/widgets/app_theme.dart';

class ConfirmarSenhaScreen extends StatefulWidget {
  const ConfirmarSenhaScreen({super.key});

  @override
  State<ConfirmarSenhaScreen> createState() => _ConfirmarSenhaScreenState();
}

class _ConfirmarSenhaScreenState extends State<ConfirmarSenhaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  bool _carregando = false;
  bool _verSenha1 = false;
  bool _verSenha2 = false;

  @override
  void dispose() {
    _tokenController.dispose();
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // const Spacer(flex: 1),
                  // Image.asset('assets/logo_policia_militar.png', height: 150),
                  // const SizedBox(height: 24),
                  Text(
                    'Recuperar senha',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text('Um código foi enviado para seu e-mail.'),
                  Text('Adicione-o abaixo para cadastrar uma nova senha.'),
                  // const Spacer(flex: 2),
                  const SizedBox(height: 24),
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Text(
                  //     'Qual seu e-mail de cadastro?',
                  //     style: TextStyle(
                  //       color: AppTheme.primary,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  TextFormField(
                    controller: _tokenController,
                    decoration: const InputDecoration(
                      hintText: 'Código de recuperação',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o código';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _novaSenhaController,
                    obscureText: !_verSenha1,
                    decoration: InputDecoration(
                      hintText: 'Nova senha*',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() => _verSenha1 = !_verSenha1);
                        },
                        icon: Icon(
                          _verSenha1 ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma senha';
                      }
                      if (value.length < 6) {
                        return 'A senha deve ter pelo menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _confirmarSenhaController,
                    obscureText: !_verSenha2,
                    decoration: InputDecoration(
                      hintText: 'Confirmar senha*',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() => _verSenha2 = !_verSenha2);
                        },
                        icon: Icon(
                          _verSenha2 ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma senha';
                      }
                      if (value != _novaSenhaController.text) {
                        return 'As senhas não coincidem';
                      }
                      return null;
                    },
                  ),
                  // const Spacer(),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _carregando ? null : _resetarSenha,
                    child: _carregando
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text('Confirmar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _resetarSenha() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _carregando = true);

    try {
      await AuthService.redefinirSenha(
        _tokenController.text,
        _novaSenhaController.text,
      );
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (_) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 4),
          content: Text(e.toString()),
          backgroundColor: AppTheme.danger,
        ),
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }
}
