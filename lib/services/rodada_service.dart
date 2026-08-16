import 'dart:convert';

import 'package:sistema_escalas_front/services/api_service.dart';

import '../models/Rodada.dart';

class RodadaService {
  static Future<List<Rodada>> listarTodas() async {
    final data = await ApiService.get('/rodada');
    return (data as List).map((j) => Rodada.fromJson(j)).toList();

    // return [
    //   Rodada(id: '1', data: DateTime(2026,06,30), escalados: []),
    //   Rodada(id: '2', data: DateTime(2026,07,05), escalados: []),
    //   Rodada(id: '3', data: DateTime(2026,07,12), escalados: []),
    // ];
  }

  static Future<List<Rodada>> proximasRodada() async {
    final data = await ApiService.get('/rodada/proximas');
    return (data as List).map((j) => Rodada.fromJson(j)).toList();
  }

  static Future<void> criar({required DateTime date}) async {
    final body = {'data': date.toIso8601String().split('T').first};
    await ApiService.post('/rodada', body);
  }

  static Future<void> deletar({required String id}) async {
    await ApiService.delete('militar/$id');
  }
}
