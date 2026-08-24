import 'package:flutter/material.dart';
import 'package:sistema_escalas_front/models/escala_extra.dart';
import 'package:sistema_escalas_front/services/escala_service.dart';
import 'package:sistema_escalas_front/utils/confirmacao_screen.dart';
import 'package:sistema_escalas_front/widgets/feedback_views.dart';

import '../widgets/app_theme.dart';

class DetalhesRodadaScreen extends StatefulWidget {
  final List<EscalaExtra> escalados;

  const DetalhesRodadaScreen({super.key, required this.escalados});

  @override
  State<DetalhesRodadaScreen> createState() => _DetalhesRodadaScreenState();
}

class _DetalhesRodadaScreenState extends State<DetalhesRodadaScreen> {
  late List<EscalaExtra> _escalados;

  @override
  void initState() {
    super.initState();

    _escalados = List.from(widget.escalados);
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
    );
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
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Militar deletado com sucesso')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao deletar militar da rodada')));
    }
  }
}
