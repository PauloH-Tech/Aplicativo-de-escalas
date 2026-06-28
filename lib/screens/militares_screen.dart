import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sistema_escalas_front/models/militar.dart';

import '../services/militar_service.dart';
import '../widgets/app_theme.dart';
import '../widgets/feedback_views.dart';

class MilitaresScreen extends StatefulWidget {
  const MilitaresScreen({super.key});

  @override
  State<MilitaresScreen> createState() => _MilitaresScreenState();
}

class _MilitaresScreenState extends State<MilitaresScreen> {
  List<Militar> _militares = [];
  bool _loanding = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    try {
      final lista = await MilitarService.listarTodos();
      setState(() {
        _militares = lista;
        _loanding = false;
      });
    } catch (e) {
      setState(() {
        _erro = e.toString();
        _loanding = false;
      });
    }
  }

  void _abrirFormulario([Militar? militar]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) =>
          _FormularioMilitar(militar: militar, onSalvo: _carregar),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loanding) return const LoandingView();
    if (_erro != null) return ErrorView(message: _erro!, onRetry: _carregar);

    return Stack(
      children: [
        _militares.isEmpty
            ? const EmptyView(
                message: 'Nenhum militar cadastrado',
                icon: Icons.person_outline,
              )
            : ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 80),
                itemCount: _militares.length,
                itemBuilder: (ctx, i) {
                  final m = _militares[i];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.primary.withOpacity(0.1),
                        child: Text(
                          m.nome.substring(0, 2).toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                      title: Text(
                        m.nome,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        m.graduacao.label,
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: AppTheme.textSecondary,
                        ),
                        onPressed: () => _abrirFormulario(m),
                      ),
                      onTap: () => _abrirFormulario(m),
                    ),
                  );
                },
              ),
        Positioned(
          bottom: 20,
          right: 16,
          child: FloatingActionButton.extended(
            onPressed: () => _abrirFormulario(),
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.person_add),
            label: const Text('Novo militar'),
          ),
        ),
      ],
    );
  }
}

class _FormularioMilitar extends StatefulWidget {
  final Militar? militar;
  final VoidCallback onSalvo;

  const _FormularioMilitar({this.militar, required this.onSalvo});

  @override
  State<StatefulWidget> createState() => _FormularioMilitarState();
}

class _FormularioMilitarState extends State<_FormularioMilitar> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  bool _ativo = true;
  Graduacao? _graduacao;

  bool _salvando = false;

  @override
  void initState() {
    super.initState();

    if (widget.militar != null) {
      _nomeController.text = widget.militar!.nome;
      _ativo = widget.militar!.stAtivo;
      _graduacao = widget.militar!.graduacao;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
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
            Text(
              widget.militar == null ? 'Novo militar' : 'Editar militar',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: 'Nome',
                prefixIcon: Icon(Icons.person_outline),
              ),
              textCapitalization: TextCapitalization.words,
              inputFormatters: [],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe o nome';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<Graduacao>(
              value: _graduacao,
              decoration: const InputDecoration(
                labelText: 'Graduação',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              items: Graduacao.values.map((graduacao) {
                return DropdownMenuItem(
                  value: graduacao,
                  child: Text(graduacao.label),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _graduacao = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Selecione uma graduação';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Ativo'),
              value: _ativo,
              onChanged: (value) {
                setState(() {
                  _ativo = value;
                });
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _salvando ? null : _salvar,
                child: _salvando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Salvar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _salvando = true;
    });

    try {
      if (widget.militar == null) {
        await MilitarService.criar(
          nome: _nomeController.text.trim(),
          graduacao: _graduacao!,
          ativo: _ativo,
        );
      } else {
        await MilitarService.editar(
          id: widget.militar!.id,
          nome: _nomeController.text.trim(),
          graduacao: _graduacao!,
          ativo: _ativo,
        );
      }

      if (!mounted) return;

      Navigator.pop(context);
      widget.onSalvo();
    } finally {
      if (mounted) {
        setState(() {
          _salvando = false;
        });
      }
    }
  }
}
