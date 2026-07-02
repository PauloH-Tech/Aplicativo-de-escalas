import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:sistema_escalas_front/models/afastamento.dart';
import 'package:sistema_escalas_front/models/militar.dart';
import 'package:sistema_escalas_front/services/militar_service.dart';
import 'package:sistema_escalas_front/widgets/feedback_views.dart';

import '../services/afastamento_service.dart';
import '../widgets/app_theme.dart';

class AfastamentoScreen extends StatefulWidget {
  const AfastamentoScreen({super.key});

  @override
  State<AfastamentoScreen> createState() => _AfastamentoScreenState();
}

class _AfastamentoScreenState extends State<AfastamentoScreen> {
  List<Afastamento> _afastamentos = [];
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
      final lista = await AfastamentoService.listar();
      setState(() {
        _afastamentos = lista;
        _loanding = false;
      });
    } catch (e) {
      setState(() {
        _erro = e.toString();
        _loanding = false;
      });
    }
  }

  Color _corTipo(TipoAfastamento tipo) {
    switch (tipo) {
      case TipoAfastamento.ferias:
        return AppTheme.success;
      case TipoAfastamento.atestado:
        return AppTheme.danger;
      case TipoAfastamento.licenca:
        return AppTheme.accent;
      case TipoAfastamento.outros:
        return AppTheme.textSecondary;
    }
  }

  void _abrirFormulario() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _FormularioAfastamento(onSalvo: _carregar),
    );
  }

  Future<void> _excluir(Afastamento a) async {}

  @override
  Widget build(BuildContext context) {
    if (_loanding) return const LoandingView();
    if (_erro != null) return ErrorView(message: _erro!, onRetry: _carregar);

    return Stack(
      children: [
        _afastamentos.isEmpty
            ? EmptyView(
                message: 'Nenhum afastamento registrado',
                icon: Icons.event_available_outlined,
              )
            : ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 20),
                itemCount: _afastamentos.length,
                itemBuilder: (ctx, i) {
                  final a = _afastamentos[i];
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (_) => _excluir(a),
                          backgroundColor: AppTheme.danger,
                          foregroundColor: Colors.white,
                          icon: Icons.delete_outline,
                          label: 'Excluir',
                        ),
                      ],
                    ),
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _corTipo(
                            a.tpAfastamento,
                          ).withOpacity(0.12),
                          child: Icon(
                            a.tpAfastamento == TipoAfastamento.ferias
                                ? Icons.beach_access_outlined
                                : a.tpAfastamento == TipoAfastamento.atestado
                                ? Icons.local_hospital_outlined
                                : Icons.event_note_outlined,
                            color: _corTipo(a.tpAfastamento),
                            size: 20,
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              a.militar.nome,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (true)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.danger.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'ativo',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppTheme.danger,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        subtitle: Text(
                          '${a.tpAfastamento.label} · '
                          '${_fmt.format(a.inicio)} → ${_fmt.format(a.fim)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  );
                },
              ),
        Positioned(
          bottom: 20,
          right: 16,
          child: FloatingActionButton.extended(
            onPressed: _abrirFormulario,
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text('Novo Afastament'),
          ),
        ),
      ],
    );
  }
}

class _FormularioAfastamento extends StatefulWidget {
  final VoidCallback onSalvo;

  const _FormularioAfastamento({required this.onSalvo});

  @override
  State<_FormularioAfastamento> createState() => _FormularioAfastamentoState();
}

class _FormularioAfastamentoState extends State<_FormularioAfastamento> {
  List<Militar> _militares = [];
  Militar? _militarSelecionado;
  TipoAfastamento _tipo = TipoAfastamento.ferias;
  DateTime? _inicio;
  DateTime? _fim;
  bool _salvando = false;
  final _fmt = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    MilitarService.listarTodos().then((lista) {
      setState(() {
        _militares = lista;
      });
    });
  }

  Future<void> _escolherPeriodo() async {
    final range = await showDateRangePicker(
      context: context,
      // initialEntryMode: DatePickerEntryMode.input,
      locale: const Locale('pt', 'BR') ,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      helpText: 'Selecione o período do afastamento',
      confirmText: 'Confirmar',
    );
    if (range != null) {
      setState(() {
        _inicio = range.start;
        _fim = range.end;
      });
    }
  }

  Future<void> _salvar() async {
    if (_militarSelecionado == null || _inicio == null || _fim == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha todos os campos')));
      return;
    }
    setState(() => _salvando = true);
    try {
      await AfastamentoService.cadastrar(
        Afastamento(
          militar: _militarSelecionado!,
          inicio: _inicio!,
          fim: _fim!,
          tpAfastamento: _tipo,
        ),
      );
      widget.onSalvo();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e'), backgroundColor: AppTheme.danger),
      );
    } finally {
      setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Novo afastamento',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<Militar>(
            value: _militarSelecionado,
            hint: const Text('Selecione o militar'),
            decoration: const InputDecoration(
              labelText: 'Militar',
              prefixIcon: Icon(Icons.person_outline),
            ),
            items: _militares
                .map((m) => DropdownMenuItem(value: m, child: Text(m.nome)))
                .toList(),
            onChanged: (m) => setState(() => _militarSelecionado = m),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<TipoAfastamento>(
            value: _tipo,
            decoration: const InputDecoration(
              labelText: 'Tipo',
              prefixIcon: Icon(Icons.category_outlined),
            ),
            items: TipoAfastamento.values
                .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                .toList(),
            onChanged: (t) => setState(() => _tipo = t!),
          ),
          const SizedBox(height: 14),
          InkWell(
            onTap: _escolherPeriodo,
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Período',
                prefixIcon: Icon(Icons.date_range_outlined),
              ),
              child: Text(
                _inicio != null && _fim != null
                    ? '${_fmt.format(_inicio!)} → ${_fmt.format(_fim!)}'
                    : 'Selecione o período',
                style: TextStyle(
                  color: _inicio != null
                      ? AppTheme.textPrimary
                      : AppTheme.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _salvando ? null : _salvar,
            child: _salvando
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
