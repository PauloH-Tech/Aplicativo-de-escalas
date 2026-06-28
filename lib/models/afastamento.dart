class Afastamento {
  final String? id;
  final String militarId;
  final DateTime inicio;
  final DateTime fim;
  final TipoAfastamento tpAfastamento;

  Afastamento({required this.id, required this.militarId, required this.inicio, required this.fim, required this.tpAfastamento});

  factory Afastamento.fromjson(Map<String, dynamic> j) => Afastamento(
    id: j['id'],
    militarId: j['militarId'],
    inicio: DateTime.parse(j['dtInicio']),
    fim: DateTime.parse(j['dtFim']),
    tpAfastamento: TipoAfastamento.fromString(j['tpAfastamento'])
  );

  Map<String, dynamic> toJson() => {
    'militarId' : militarId,
    'dtInicio' : inicio.toIso8601String().split('T').first,
    'dtFim' : fim.toIso8601String().split('T').first,
    'tpAfastamento' : tpAfastamento
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