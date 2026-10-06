import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:escalas_extras/models/acesso_usuario.dart';
import 'package:escalas_extras/models/usuario.dart';
import 'package:escalas_extras/services/auth_service.dart';
import 'package:escalas_extras/utils/navegacao_auth.dart';
import 'package:escalas_extras/widgets/app_theme.dart';
import 'package:escalas_extras/widgets/feedback_views.dart';

import '../models/rodada.dart';
import '../services/rodada_service.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  List<Rodada> _rodadas = [];
  bool _loading = true;
  String? _erro;
  final _fmt = DateFormat('dd/MM/yyyy (EEEE)', 'pt_BR');
  // late Usuario? _usuario;
  final Usuario? _usuario = AuthService.usuarioAtual;

  @override
  void initState() {
    super.initState();
    // _carregarUsuario();
    _carregar();
  }

  // Future<void> _carregarUsuario() async {
  //   final user = AuthService.usuarioAtual;
  //   if (user!.nome.length >= 15) {
  //     user.nome.substring(1, 15);
  //   }
  //   setState(() {
  //     _usuario = user;
  //   });

  // }

  Future<void> _carregar() async {
    setState(() {
      _loading = true;
      _erro = null;
    });
    try {
      //TODO: paginado mostrar algumas de um tempo atras e todas no futuro, feitas e ainda não feitas
      //mostrar as rodadas onde o usuario esta escalado,
      final lista = await RodadaService.rodadasDoMilitar();
      setState(() {
        _rodadas = lista;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _erro = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70, //
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bem-vindo(a), ${_usuario!.nome}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white70, // Um tom mais suave para o boas-vindas
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Minhas escalas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout),
            onPressed: () => NavegacaoAuth.sair(context),
          ),
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    if (_loading) return const LoadingView();
    //TODO: interessante talvez mostrei o botao de logout quando der 401 Não autenticado
    if (_erro != null) return ErrorView(message: _erro!, onRetry: _carregar);
    if (_rodadas.isEmpty) {
      return const EmptyView(
        message: 'Nenhuma rodada prevista',
        icon: Icons.event_available_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _rodadas.length,
        itemBuilder: (context, i) {
          final rodada = _rodadas[i];
          return Card(
            child: ExpansionTile(
              shape: const Border(),
              leading: const Icon(
                Icons.calendar_month_outlined,
                color: AppTheme.primary,
              ),
              title: Text(_fmt.format(rodada.data)),
              subtitle: Text('${rodada.escalados.length} escalado(s)'),
              children: rodada.escalados.isEmpty
                  ? [const ListTile(title: Text('Ninguém escalado ainda'))]
                  : [
                      const Divider(height: 1, thickness: 1),
                      ...rodada.escalados.map(
                        (e) => ListTile(
                          dense: true,
                          leading: const Icon(Icons.person_outline),
                          title: Text(e.militar.nome),
                          subtitle: Text(e.militar.graduacao.label),
                          // sem botão de excluir: usuário só consulta
                        ),
                      ),
                    ],
            ),
          );
        },
      ),
    );
  }
}
