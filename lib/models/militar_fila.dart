import 'package:escalas_extras/models/afastamento.dart';
import 'package:escalas_extras/models/militar.dart';

class MilitarFila {
  final String id;
  final String nome;
  final Graduacao graduacao;
  final DateTime? dtUltimaEscala;
  final TipoAfastamento? tpAfastamento;
  final int qtEscalas;

  MilitarFila({
    required this.id,
    required this.nome,
    required this.graduacao,
    required this.dtUltimaEscala,
    this.tpAfastamento,
    required this.qtEscalas,
  });

  factory MilitarFila.fromJson(Map<String, dynamic> j) {
    return MilitarFila(
      id: j['idMilitar'],
      nome: j['nome'],
      graduacao: Graduacao.fromString(j['graduacao']),
      dtUltimaEscala: j['dtUltimaEscala'] != null
          ? DateTime.parse(j['dtUltimaEscala'])
          : null,
      tpAfastamento: j['tpAfastamento'] != null
          ? TipoAfastamento.fromString(j['tpAfastamento'])
          : null,
      qtEscalas: j['qtEscalas'],
    );
  }

  @override
  String toString() {
    return 'MilitarFila{id: $id, nome: $nome, graduacao: $graduacao, dtUltimaEscala: $dtUltimaEscala, tpAfastamento: $tpAfastamento, qtEscalas: $qtEscalas}';
  }
}
