import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:escalas_extras/screens/login_screen.dart';
import 'package:escalas_extras/services/auth_service.dart';
import 'package:escalas_extras/widgets/app_theme.dart';

class CriarContaScreen extends StatefulWidget {
  const CriarContaScreen({super.key});

  @override
  State<CriarContaScreen> createState() => _CriarContaScreenState();
}

class _CriarContaScreenState extends State<CriarContaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  final _nomeController = TextEditingController();
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
    _nomeController.dispose();
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
                    'Criar conta',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Um código foi enviado para seu e-mail.\nAdicione-o abaixo para concluir a criação da sua conta.',
                    textAlign: TextAlign.center,
                  ),

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
                      hintText: 'Código de autenticação',
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
                    controller: _nomeController,
                    decoration: InputDecoration(hintText: 'Nome de usuário*'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um nome de usuário';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _novaSenhaController,
                    obscureText: !_verSenha1,
                    decoration: InputDecoration(
                      hintText: 'Senha*',
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
                    onPressed: _carregando ? null : _confirmarAcesso,
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

  Future<void> _confirmarAcesso() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _carregando = true);

    try {
      await AuthService.confirmarPrimeiroAcesso(
        _tokenController.text,
        _nomeController.text.trim(),
        _novaSenhaController.text,
      );
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (_) => false,
      );
    } on ClientException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 4),
          content: Text('Sem conexão com a internet:\n${e.message}'),
          backgroundColor: AppTheme.danger,
        ),
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
