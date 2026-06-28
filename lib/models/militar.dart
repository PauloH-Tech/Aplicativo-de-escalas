class Militar {
  final String id;
  final String nome;
  final bool stAtivo;
  //final DateTime? dataIngresso;
  final Graduacao graduacao;
  // campos calculados pela query de ordenação (só vêm na lista da fila)
  // final int? qtdEscalas;
  // final Enum? tpAfastamento;
  // final DateTime? dtUltimaEscala;

  Militar({
    required this.id,
    required this.nome,
    required this.stAtivo,
    required this.graduacao
    // this.qtdEscalas,
    // this.dtUltimaEscala,
    // this.tpAfastamento
  });

  factory Militar.fromJson(Map<String, dynamic> j) => Militar(
    id: j['id'],
    nome: j['nome'],
    stAtivo: j['st_ativo'] ?? j['st_ativo'] ?? true,
    graduacao: Graduacao.fromString(j['graduacao'])
  );

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'st_ativo': stAtivo,
    'id': id,
    'graduacao': graduacao.value
  };

  // Porcentagem formatada da taxa para exibir no card
  // String get taxaFormatada {
  //   if (taxaEscalas == null) return '—';
  //   return '${(taxaEscalas! * 100).toStringAsFixed(0)}%';
  // }
}

enum Graduacao {
  soldado('SOLDADO', 'Soldado'),
  cabo('CABO', 'Cabo'),
  terceiroSargento('TERCEIRO_SARGENTO', '3° Sargento'),
  segundoSargento('SEGUNDO_SARGENTO', '2° Sargento'),
  primeiroSargento('PRIMEIRO_SARGENTO', '1° Sargento'),
  outros('OUTROS', 'Outros');

  final String value;
  final String label;
  const Graduacao(this.value, this.label);

  static Graduacao fromString(String v) => Graduacao.values.firstWhere(
    (e) => e.value == v,
    orElse: () => Graduacao.outros,
  );
}
