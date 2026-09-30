import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sistema_escalas_front/models/rodada.dart';
import 'package:sistema_escalas_front/models/escala_extra_request.dart';
import 'package:sistema_escalas_front/services/escala_service.dart';
import 'package:sistema_escalas_front/services/rodada_service.dart';
import 'package:sistema_escalas_front/widgets/feedback_views.dart';

import '../models/militar_fila.dart';
import '../widgets/app_theme.dart';
import '../widgets/posto_badge.dart';

class FilaScreen extends StatefulWidget {
  const FilaScreen({super.key});

  @override
  State<FilaScreen> createState() => _FilaScreenState();
}

class _FilaScreenState extends State<FilaScreen> {
  List<MilitarFila> _fila = [];
  // final Map<String, int> _posicoesDisponiveis = {};
  List<Rodada> _rodadas = [];
  Rodada? _rodadaSelecionada;
  final Set<String> _selecionados = {};
  bool _loading = true;
  String? _erro;
  final _fmt = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _carregarRodadas();
  }

  Future<void> _carregarRodadas() async {
    setState(() {
      _loading = true;
      _erro = null;
    });
    try {
      final rodadas = await RodadaService.proximasRodada();

      setState(() {
        _rodadas = rodadas;
        _rodadaSelecionada = null;
        _fila.clear();
        _selecionados.clear();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _erro = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _carregarFila(Rodada rodada) async {
    setState(() {
      _loading = true;
      _erro = null;
      _selecionados.clear();
    });
    try {
      final fila = await EscalaService.listaOrdenada(date: rodada.data);
      setState(() {
        _fila = fila;
        _rodadaSelecionada = rodada;
        _loading = false;

        // _posicoesDisponiveis.clear();
        // int posicaoDisponivel = 1;
        // for (final militar in _fila) {
        //   if (militar.tpAfastamento == null) {
        //     _posicoesDisponiveis[militar.id] = posicaoDisponivel++;
        //   }
        // }
      });
    } catch (e) {
      setState(() {
        _erro = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _confirmarEscala() async {
    if (_rodadaSelecionada == null || _selecionados.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar escala'),
        content: Text(
          '${_selecionados.length} militar(res) serão escalados na rodada do dia ${_fmt.format(_rodadaSelecionada!.data)}.\n\nDeseja confirmar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      await EscalaService.escalarMilitares(
        escalados: EscalaExtraRequest(
          militarIds: _selecionados.toList(),
          rodadaId: _rodadaSelecionada!.id,
        ),
      );
      setState(() => _selecionados.clear());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Escala registrada com sucesso!'),
          backgroundColor: AppTheme.success,
        ),
      );
      _carregarRodadas();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e'), backgroundColor: AppTheme.danger),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const LoadingView();
    if (_erro != null) {
      return ErrorView(
        message: _erro!,
        onRetry: _rodadaSelecionada == null
            ? _carregarRodadas
            : () => _carregarFila(_rodadaSelecionada!),
      );
    }

    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              const Text(
                'Rodada: ',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<Rodada>(
                  initialValue: _rodadaSelecionada,
                  hint: _rodadas.isEmpty
                      ? const Text('Sem rodadas para selecionar')
                      : const Text('Selecione'),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  items: _rodadas
                      .map(
                        (r) => DropdownMenuItem(
                          value: r,
                          child: Text(_fmt.format(r.data)),
                        ),
                      )
                      .toList(),
                  onChanged: (r) {
                    if (r != null) {
                      _carregarFila(r);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        //add legenda
        Expanded(
          child: _rodadaSelecionada == null
              ? Center(
                  child: const Text(
                    'Selecione uma rodada para visualizar a fila',
                  ),
                )
              : _fila.isEmpty
              ? const EmptyView(
                  message: 'Nenhum militar disponível',
                  icon: Icons.people_outline,
                )
              : ListView.builder(
                  itemCount: _fila.length,
                  itemBuilder: (ctx, i) {
                    final m = _fila[i];
                    final sel = _selecionados.contains(m.id);
                    final bool podeEscalar = m.tpAfastamento == null;
                    return _MilitarFilaCard(
                      militarFila: m,
                      // posicao: _posicoesDisponiveis[m.id],
                      posicao: i + 1,
                      selecionado: sel,
                      rodadaSelecionada: true,
                      podeEscalar: podeEscalar,
                      ultimaEscala: _fmt.format(m.dtUltimaEscala!),
                      onTap: () {
                        setState(() {
                          if (sel) {
                            _selecionados.remove(m.id);
                          } else {
                            _selecionados.add(m.id);
                          }
                        });
                      },
                    );
                  },
                ),
        ),

        if (_selecionados.isNotEmpty)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton.icon(
                onPressed: _confirmarEscala,
                icon: const Icon(Icons.check_circle_outline),
                label: Text('Confirmar ${_selecionados.length} escalas(s)'),
              ),
            ),
          ),
      ],
    );
  }
}

class _MilitarFilaCard extends StatelessWidget {
  final MilitarFila militarFila;
  final int posicao;
  final bool selecionado;
  final bool rodadaSelecionada;
  final VoidCallback onTap;
  final bool podeEscalar;
  final String ultimaEscala;

  const _MilitarFilaCard({
    super.key,
    required this.militarFila,
    required this.posicao,
    required this.selecionado,
    required this.rodadaSelecionada,
    required this.podeEscalar,
    required this.onTap,
    required this.ultimaEscala,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: podeEscalar ? 1 : 0.55,
      child: Card(
        color: podeEscalar ? Colors.white : Colors.grey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: selecionado ? AppTheme.primary : AppTheme.border,
            width: selecionado ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: podeEscalar ? onTap : null,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: PostoBadge(posicao),
                        title: Text(
                          militarFila.nome,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Text(
                          'Escalas: ${militarFila.qtEscalas}\nUltima: $ultimaEscala',
                        ),
                        trailing: militarFila.tpAfastamento != null
                            ? Text(
                                militarFila.tpAfastamento!.label,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 2),
                    ],
                  ),
                ),
                if (rodadaSelecionada)
                  Checkbox(
                    value: selecionado,
                    onChanged: podeEscalar ? (_) => onTap() : null,
                    activeColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
