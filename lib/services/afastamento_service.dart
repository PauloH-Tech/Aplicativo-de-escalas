import 'package:sistema_escalas_front/models/afastamento.dart';

import 'api_service.dart';

class AfastamentoService {
  //deve receber o nome do policial ao inves do id
  static Future<List<Afastamento>> listar() async {
    final data = await ApiService.get('/afastamento');
    // print(data.toString());
    return (data as List).map((j) => Afastamento.fromjson(j)).toList();

    // return [
    //   Afastamento(
    //     id: '1',
    //     militar: Militar(
    //       id: '1',
    //       nome: 'DOS SANTOS',
    //       stAtivo: true,
    //       graduacao: Graduacao.segundoSargento,
    //     ),
    //     inicio: DateTime(2026, 06, 29),
    //     fim: DateTime(2026, 07, 29),
    //     tpAfastamento: TipoAfastamento.licenca,
    //   ),
    //   Afastamento(
    //     id: '2',
    //     militar: Militar(
    //       id: '2',
    //       nome: 'JULIANA',
    //       stAtivo: true,
    //       graduacao: Graduacao.cabo,
    //     ),
    //     inicio: DateTime(2026, 07, 15),
    //     fim: DateTime(2026, 07, 30),
    //     tpAfastamento: TipoAfastamento.atestado,
    //   ),
    // ];
  }

  static Future<void> cadastrar({
    required String idMilitar,
    required DateTime dtInicio,
    required DateTime dtFim,
    required TipoAfastamento tipo,

  }) async {
    final body = {
      'dtInicio' : dtInicio.toIso8601String().split('T').first,
      'dtFim' : dtFim.toIso8601String().split('T').first,
      'tpAfastamento' : tipo.value
    } ;
    await ApiService.post('/afastamento/$idMilitar', body);
  }

  static Future<void> deletar({required String id}) async {
    await ApiService.delete('/afastamento/$id');
  }
}
