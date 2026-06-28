import 'dart:convert';

import 'package:sistema_escalas_front/services/api_service.dart';

import '../models/Rodada.dart';

class RodadaService {
  static Future<List<Rodada>> listar() async {
    final data = await ApiService.get('/rodada');
    return (data as List).map((j) => Rodada.fromJson(j)).toList();
  }

  static Future<void> criar(DateTime data) async {
    final body = {'data': data.toIso8601String().split('T').first};
    await ApiService.post('/rodada', body);
  }
}
