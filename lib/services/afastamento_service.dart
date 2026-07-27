import 'package:sistema_escalas_front/models/afastamento.dart';
import 'package:sistema_escalas_front/models/militar.dart';

import 'api_service.dart';

class AfastamentoService {
  //deve receber o nome do policial ao inves do id
  static Future<List<Afastamento>> listar() async {
    // final data = await ApiService.get('/afastamento', null);
    // print(data.toString());
    // return (data as List).map((j) => Afastamento.fromjson(j)).toList();

    return [
      Afastamento(
        id: '1',
        militar: Militar(
          id: '1',
          nome: 'DOS SANTOS',
          stAtivo: true,
          graduacao: Graduacao.segundoSargento,
        ),
        inicio: DateTime(2026, 06, 29),
        fim: DateTime(2026, 07, 29),
        tpAfastamento: TipoAfastamento.licenca,
      ),
      Afastamento(
        id: '2',
        militar: Militar(
          id: '2',
          nome: 'JULIANA',
          stAtivo: true,
          graduacao: Graduacao.cabo,
        ),
        inicio: DateTime(2026, 07, 15),
        fim: DateTime(2026, 07, 30),
        tpAfastamento: TipoAfastamento.atestado,
      ),
    ];
  }

  //mandar o id do policial
  static Future<void> cadastrar(Afastamento afastamento) async {
    final idMilitar = afastamento.militar.id;
    final body = afastamento.toJson();
    await ApiService.post('/afastamento', body, idMilitar);
  }
}
