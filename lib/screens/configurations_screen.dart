import 'package:flutter/material.dart';
import 'package:escalas_extras/config/app_config.dart';
import '../../widgets/app_theme.dart';

class ConfiguracoesScreen extends StatefulWidget {
  const ConfiguracoesScreen({super.key});

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  final TextEditingController urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    urlController.text = AppConfig.apiUrl;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Configurações')),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Contato do desenvolvedor'),
          Spacer(), //ocupa todo os espaço
          Align(
            alignment: Alignment.bottomCenter,
            child: const Text(
              'Versão do app: 1.0.0',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
          ),
          // const SizedBox(height: 20),
          // TextField(
          //   controller: urlController,
          //   decoration: InputDecoration(
          //     labelText: 'URL da API',
          //     border: OutlineInputBorder(),
          //   ),
          // ),
          // const SizedBox(height: 20),
          // ElevatedButton(onPressed: () async {
          //   await AppConfig.setApiUrl(urlController.text);

          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('URL salva!')),);
          // }, child: Text('Salvar')),
        ],
      ),
    ),
  );
}
