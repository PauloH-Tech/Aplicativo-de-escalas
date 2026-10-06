import 'package:flutter/material.dart';
import 'package:escalas_extras/models/escala_extra_request.dart';
import 'package:escalas_extras/models/militar_fila.dart';
import 'package:escalas_extras/models/rodada.dart';
import 'package:escalas_extras/models/escala_extra.dart';
import 'package:escalas_extras/services/api_service.dart';
import 'package:escalas_extras/services/escala_service.dart';
import 'package:escalas_extras/utils/confirmacao_screen.dart';
import 'package:escalas_extras/widgets/feedback_views.dart';

import '../widgets/app_theme.dart';

class DetalhesRodadaScreen extends StatefulWidget {
  final Rodada rodada;

  const DetalhesRodadaScreen({super.key, required this.rodada});

  @override
  State<DetalhesRodadaScreen> createState() => _DetalhesRodadaScreenState();
}

class _DetalhesRodadaScreenState extends State<DetalhesRodadaScreen> {
  late List<EscalaExtra> _escalados;

  @override
  void initState() {
    super.initState();

    _escalados = List.from(widget.rodada.escalados);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da rodada')),
      body: _escalados.isEmpty
          ? const EmptyView(
              message: 'Nenhum militar escalado nesta rodada',
              icon: Icons.person_outline,
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemCount: _escalados.length,
                separatorBuilder: (_, __) => const Divider(height: 2),
                itemBuilder: (context, index) {
                  final escala = _escalados[index];
                  final militar = escala.militar;

                  return ListTile(
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppTheme.primary.withOpacity(0.1),
                      child: Text(
                        militar.nome.substring(0, 2),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                    title: Text(militar.nome),
                    subtitle: Text(militar.graduacao.label),
                    trailing: IconButton(
                      onPressed: () => _excluir(index, escala.id),
                      icon: Icon(Icons.delete),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMilitar,
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _addMilitar() async {
    final jaEscalados = _escalados.map((e) => e.militar.id).toSet();
    final fila = await EscalaService.listaOrdenada(date: widget.rodada.data);
    final candidatos = fila.where((m) => !jaEscalados.contains(m.id)).toList();
    if (!mounted) return;

    final escolhido = await showModalBottomSheet<MilitarFila>(
      context: context,
      builder: (ctx) => ListView(
        children: [
          for (final m in candidatos)
            ListTile(
              title: Text(m.nome),
              subtitle: Text(m.tpAfastamento?.label ?? m.graduacao.label),
              enabled: m.tpAfastamento == null,
              onTap: () => Navigator.pop(ctx, m),
            ),
        ],
      ),
    );
    if (escolhido == null) return;

    try {
      final criadas = await EscalaService.escalarMilitares(
        escalados: EscalaExtraRequest(
          rodadaId: widget.rodada.id,
          militarIds: [escolhido.id],
        ),
      );
      if (!mounted) return;
      setState(() => _escalados.addAll(criadas));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _excluir(int index, String id) async {
    final confirmar = await Confirmacao.mostrarDialogoConfirmacao(
      context,
      'Deletar',
      'Deseja realmente deletar esse militar da rodada ?',
    );
    if (!confirmar) return;
    try {
      await EscalaService.deletarEscalado(id: id);
      if (!mounted) return;
      setState(() {
        _escalados.removeAt(index);
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Militar deletado com sucesso')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar militar da rodada')),
      );
    }
  }
}
