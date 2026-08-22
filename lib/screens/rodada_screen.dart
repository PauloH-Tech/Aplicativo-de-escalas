import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sistema_escalas_front/screens/detalhes_rodada_screen.dart';
import 'package:sistema_escalas_front/widgets/feedback_views.dart';

import '../models/Rodada.dart';
import '../services/rodada_service.dart';
import '../widgets/app_theme.dart';

class RodadaScreen extends StatefulWidget {
  const RodadaScreen({super.key});

  @override
  State<RodadaScreen> createState() => _RodadaScreenState();
}

class _RodadaScreenState extends State<RodadaScreen> {
  List<Rodada> _rodadas = [];
  bool _loanding = true;
  String? _erro;
  final _fmt = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() {
      _loanding = true;
      _erro = null;
    });
    try {
      final lista = await RodadaService.listarTodas();
      setState(() {
        _rodadas = lista;
        _loanding = false;
      });
    } catch (e) {
      setState(() {
        _erro = e.toString();
        _loanding = false;
      });
    }
  }

  Future<void> _criarRodada() async {
    DateTime? data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      locale: Locale('pt', 'BR'),
      helpText: 'Selecione a data da escala',
      confirmText: 'Criar rodada',
      // cancelText: 'Cancelar',
    );
    if (data == null) return;

    try {
      // print(data);
      await RodadaService.criar(date: data);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rodada criada com sucesso!'),
          backgroundColor: AppTheme.success,
        ),
      );
      _carregar();
    } catch (e) {
      // print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e'), backgroundColor: AppTheme.danger),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loanding) return LoandingView();
    if (_erro != null) return ErrorView(message: _erro!, onRetry: _carregar);

    return Stack(
      children: [
        _rodadas.isEmpty
            ? const EmptyView(
                message: 'Nenhuma rodada cadastrada',
                icon: Icons.calendar_today_outlined,
              )
            : ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 80),
                itemCount: _rodadas.length,
                itemBuilder: (ctx, i) {
                  final r = _rodadas[i];
                  return Card(
                    child: ListTile(
                      // leading: CircleAvatar(
                      //   // backgroundColor: AppTheme.primary,
                      //   // child: Text(
                      //   //   '#${r.data}',
                      //   //   style: const TextStyle(
                      //   //     color: Colors.white,
                      //   //     fontSize: 12,
                      //   //     fontWeight: FontWeight.bold,
                      //   //   ),
                      //   // ),
                      //   child: Icon(Icons.calendar_today_outlined),
                      // ),
                      title: Text(
                        'Rodada ${_fmt.format(r.data)}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: r.escalados.isEmpty
                          ? Text('Nenhum militar escalado')
                          : r.escalados.length == 1
                          ? Text('${r.escalados.length} militar escalado')
                          : Text('${r.escalados.length} militares escalados'),
                      trailing: r.escalados.isNotEmpty
                          ? IconButton(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetalhesRodadaScreen(
                                      escalados: r.escalados,
                                    ),
                                  ),
                                );
                                _carregar();
                              },
                              icon: Icon(Icons.chevron_right),
                              color: AppTheme.textSecondary,
                            )
                          : null,
                    ),
                  );
                },
              ),
        Positioned(
          bottom: 20,
          right: 16,
          child: FloatingActionButton.extended(
            onPressed: _criarRodada,
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text('Nova Rodada'),
          ),
        ),
      ],
    );
  }
}
