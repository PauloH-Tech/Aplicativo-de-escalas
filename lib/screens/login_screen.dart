import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sistema_escalas_front/screens/criar_conta.dart';
import 'package:sistema_escalas_front/screens/confirmar_email.dart';
import 'package:sistema_escalas_front/services/auth_service.dart';
import 'package:sistema_escalas_front/utils/navegacao_auth.dart';
import 'package:sistema_escalas_front/widgets/app_theme.dart';

//TODO: esta causando overflow quando usa o teclado
//TODO:futuro mudar o token temporario para um codigo de 6 digitos (parecido com demais apps)

//TODO: verificar se causa excepetions quando o token expira e estou com shared
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usuarioController = TextEditingController(text: 'admin@escalas.com.br');
  final _senhaController = TextEditingController(text: 'admin123');
  final _formKey = GlobalKey<FormState>();
  bool _carregando = false;
  bool _verSenha = false;

  @override
  void dispose() {
    _usuarioController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _carregando = true);

    try {
      final usuario = await AuthService.login(
        _usuarioController.text.trim(),
        _senhaController.text,
      );
      if (!mounted) return;
      NavegacaoAuth.irParaHome(context, usuario);
    } on ClientException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 4),
          content: Text('Sem conexão com a internet:\n${e.message}'),
          backgroundColor: AppTheme.danger,
        ),
      );
    } on TimeoutException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 4),
          content: Text(
            'Ops! A conexão demorou muito a responder. Verifique sua internet e tente novamente.',
          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 48,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Spacer(flex: 4),
                        Image.asset(
                          'assets/logo_policia_militar.png',
                          height: 150,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _usuarioController,
                          decoration: const InputDecoration(
                            labelText: 'Usuário',
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira um usuário';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _senhaController,
                          obscureText: !_verSenha,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            prefixIcon: const Icon(Icons.password),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() => _verSenha = !_verSenha);
                              },
                              icon: Icon(
                                _verSenha
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira uma senha';
                            }
                            return null;
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ConfirmarEmailScreen(
                                        titulo: 'Esqueceu a senha ?',
                                        mensagem:
                                            'Redefina a senha em duas etapas',
                                        acesso: 'RESET',
                                      ),
                                ),
                              );
                            },
                            child: Text('Esqueci a minha senha'),
                          ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: _carregando ? null : _entrar,
                          child: _carregando
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Fazer login'),
                        ),
                        const Spacer(flex: 2),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Colors.grey,
                                endIndent: 10,
                              ),
                            ),
                            Text('ou'),
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Colors.grey,
                                indent: 10,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ConfirmarEmailScreen(
                                      titulo: "Criar sua conta ?",
                                      mensagem: 'criei sua conta agora',
                                      acesso: 'FIRST',
                                    ),
                              ),
                            );
                          },
                          child: const Text('Criar conta'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
