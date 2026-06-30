import 'package:sistema_escalas_front/models/militar.dart';

class Afastamento {
  final String? id;
  final Militar militar;
  final DateTime inicio;
  final DateTime fim;
  final TipoAfastamento tpAfastamento;

  Afastamento({this.id, required this.militar, required this.inicio, required this.fim, required this.tpAfastamento});

  factory Afastamento.fromjson(Map<String, dynamic> j) => Afastamento(
    id: j['id'],
    militar: Militar.fromJson(j['militar']),
    inicio: DateTime.parse(j['dtInicio']),
    fim: DateTime.parse(j['dtFim']),
    tpAfastamento: TipoAfastamento.fromString(j['tpAfastamento'])
  );

  Map<String, dynamic> toJson() => {
    'dtInicio' : inicio.toIso8601String().split('T').first,
    'dtFim' : fim.toIso8601String().split('T').first,
    'tpAfastamento' : tpAfastamento.value
  };

}

enum TipoAfastamento {
  ferias('FERIAS', 'Férias'),
  licenca('LICENCA', 'Licença'),
  atestado('ATESTADO', 'Atestado Médico'),
  outros('OUTROS', 'Outros');

  final String value;
  final String label;

  const TipoAfastamento(this.value, this.label);

  static TipoAfastamento fromString(String v) =>
      TipoAfastamento.values.firstWhere(
          (e) => e.value == v, orElse: () => TipoAfastamento.outros,
      );
}