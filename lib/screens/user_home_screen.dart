import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sistema_escalas_front/services/auth_service.dart';
import 'package:sistema_escalas_front/utils/navegacao_auth.dart';
import 'package:sistema_escalas_front/widgets/app_theme.dart';
import 'package:sistema_escalas_front/widgets/feedback_views.dart';

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

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() {
      _loading = true;
      _erro = null;
    });
    try {
      final lista = await RodadaService.listarTodas();
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
        title: const Text('Minhas escalas'),
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
              leading: const Icon(
                Icons.calendar_month_outlined,
                color: AppTheme.primary,
              ),
              title: Text(_fmt.format(rodada.data)),
              subtitle: Text('${rodada.escalados.length} escalado(s)'),
              children: rodada.escalados.isEmpty
                  ? [const ListTile(title: Text('Ninguém escalado ainda'))]
                  : rodada.escalados
                        .map(
                          (e) => ListTile(
                            dense: true,
                            leading: const Icon(Icons.person_outline),
                            title: Text(e.militar.nome),
                            subtitle: Text(e.militar.graduacao.label),
                            // sem botão de excluir: usuário só consulta
                          ),
                        )
                        .toList(),
            ),
          );
        },
      ),
    );
  }
}
