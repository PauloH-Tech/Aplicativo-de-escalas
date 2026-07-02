import 'package:sistema_escalas_front/models/escala_extra_request.dart';
import 'package:sistema_escalas_front/services/api_service.dart';

import '../models/militar_fila.dart';

class EscalaService {
  static Future<List<MilitarFila>> listaOrdenada(DateTime date) async {
    var dataFormatada = date.toIso8601String().split('T').first;
    // print(dataFormatada);
    var data = await ApiService.get('/escala', dataFormatada);
    // print(data);
    return (data as List).map((j) => MilitarFila.fromJson(j)).toList();


    // return [
    //   Militar(
    //     id: '1',
    //     nome: 'DOS SANTOS',
    //     stAtivo: true,
    //     graduacao: Graduacao.segundoSargento,
    //   ),
    //   Militar(
    //     id: '2',
    //     nome: 'TEIXEIRA',
    //     stAtivo: true,
    //     graduacao: Graduacao.cabo,
    //   ),
    //   Militar(
    //     id: '3',
    //     nome: 'JULIANA',
    //     stAtivo: true,
    //     graduacao: Graduacao.terceiroSargento,
    //   ),
    // ];
  }

  static Future<void> escalarMilitares({
    required EscalaExtraRequest escalados
  }) async {
    var body = escalados.toJson();
    // print(body);
    await ApiService.post('/escala', body, null);
  }
}
