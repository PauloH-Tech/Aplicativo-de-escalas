import 'package:flutter/material.dart';
import 'package:sistema_escalas_front/models/escala_extra.dart';

class DetalhesRodadaScreen extends StatelessWidget {
  final List<EscalaExtra> escalados;

  const DetalhesRodadaScreen({super.key, required this.escalados});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da rodada')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemCount: escalados.length,
          separatorBuilder: (_, __) => const Divider(height: 2,),
          itemBuilder: (context, index) {
            final escala = escalados[index];
            final militar = escala.militar;

            return ListTile(
              leading: const Icon(Icons.person),
              title: Text(militar.nome),
              subtitle: Text(militar.graduacao.label),
            );
          },
        ),
      ),
    );
  }
}
