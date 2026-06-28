class Rodada {
  final String id;
  final DateTime data;

  Rodada({required this.id, required this.data});

  factory Rodada.fromJson(Map<String, dynamic> j) =>
      Rodada(id: j['id'], data: DateTime.parse(j['data']));

  // factory Rodada.fromJson(Map<String, dynamic> j) {
  //   final partes = j['data'].split('/');
  //
  //   return Rodada(
  //     id: j['id'],
  //     data: DateTime(
  //       int.parse(partes[2]), // ano
  //       int.parse(partes[1]), // mês
  //       int.parse(partes[0]), // dia
  //     ),
  //   );
  // }

  Map<String, dynamic> toJson() => {
    // 'id' : id,
    'data': data.toIso8601String().split('T').first,
  };
}
