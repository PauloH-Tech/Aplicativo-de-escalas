import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:escalas_extras/screens/criar_conta.dart';
import 'package:escalas_extras/screens/resetar_senha.dart';
import 'package:escalas_extras/services/auth_service.dart';
import 'package:escalas_extras/widgets/app_theme.dart';

class ConfirmarEmailScreen extends StatefulWidget {
  final String titulo;
  final String mensagem;
  final String acesso;

  const ConfirmarEmailScreen({
    super.key,
    required this.titulo,
    required this.mensagem,
    required this.acesso,
  });

  @override
  State<ConfirmarEmailScreen> createState() => _ConfirmarEmailScreenState();
}

class _ConfirmarEmailScreenState extends State<ConfirmarEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _carregando = false;

  @override
  void dispose() {
    _emailController.dispose();
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
                  Image.asset('assets/logo_policia_militar.png', height: 150),
                  const SizedBox(height: 24),
                  Text(
                    widget.titulo,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(widget.mensagem),
                  // const Spacer(flex: 2),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Qual seu e-mail de cadastro?',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Digite seu e-mail',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um e-mail';
                      }
                      return null;
                    },
                  ),
                  // const Spacer(),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _carregando ? null : _confirmarEmail,
                    child: _carregando
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text('Enviar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmarEmail() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _carregando = true);

    try {
      switch (widget.acesso) {
        case 'RESET':
          dev.log('Esqueci a senha');
          await AuthService.esqueciSenha(_emailController.text.trim());
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ResetarSenhaScreen()),
          );
        case 'FIRST':
          dev.log('Primeiro acesso');
          await AuthService.primeiroAcesso(_emailController.text.trim());
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CriarContaScreen()),
          );
      }
    } on ClientException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 4),
          content: Text('Sem conexão com a internet:\n${e.message}'),
          backgroundColor: AppTheme.danger,
        ),
      );
    } catch (e) {
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
