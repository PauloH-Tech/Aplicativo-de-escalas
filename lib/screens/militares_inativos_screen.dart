import 'package:flutter/material.dart';
import 'package:sistema_escalas_front/models/militar.dart';
import 'package:sistema_escalas_front/services/militar_service.dart';
import 'package:sistema_escalas_front/widgets/feedback_views.dart';

import '../utils/confirmacao_screen.dart';

class MilitaresInativosScreen extends StatefulWidget {
  const MilitaresInativosScreen({super.key});

  @override
  State<MilitaresInativosScreen> createState() =>
      _MilitaresInativosScreenState();
}

class _MilitaresInativosScreenState extends State<MilitaresInativosScreen> {
  List<Militar> _militaresInativos = [];
  bool _loading = true;
  String? _erro;

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
      final lista = await MilitarService.listarInativos();
      setState(() {
        _militaresInativos = lista;
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
      appBar: AppBar(title: const Text('Militares Inativos')),
      body: _loading
          ? const LoadingView()
          : _erro != null
          ? ErrorView(message: _erro!, onRetry: _carregar)
          : _militaresInativos.isEmpty
          ? const EmptyView(
              message: 'Nenhum militar inativo',
              icon: Icons.person_outline,
            )
          : Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.separated(
                itemCount: _militaresInativos.length,
                separatorBuilder: (_, __) => const Divider(height: 2),
                itemBuilder: (context, index) {
                  final militar = _militaresInativos[index];

                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(militar.nome),
                    subtitle: Text(militar.graduacao.label),
                    trailing: IconButton(
                      onPressed: () async {
                        final confirmar =
                            await Confirmacao.mostrarDialogoConfirmacao(
                              context,
                              'Ativar',
                              'Deseja realmente ativar esse militar ?',
                            );
                        if (!confirmar) return;

                        print('ativandoo');
                        final sucesso = await _ativar(militar.id);
                        print('deu certo ? $sucesso');

                        if (!mounted) return;

                        if (!sucesso) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Erro ao ativar militar'),
                            ),
                          );
                          return;
                        }
                        setState(() {
                          _militaresInativos.removeWhere(
                                (m) => m.id == militar.id,
                          );
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Militar ativado com sucesso'),
                          ),
                        );
                      },
                      icon: Icon(Icons.check_circle_outline),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Future<bool> _ativar(String idMilitar) async {
    try {
      await MilitarService.ativar(id: idMilitar);
      return true;
    } catch (e) {
      return false;
    }
  }
}
