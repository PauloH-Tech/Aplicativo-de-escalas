import 'Rodada.dart';
import 'militar.dart';

class EscalaExtra {
  final String id;
  final Militar militar;
  // final Rodada rodada;

  EscalaExtra({required this.id, required this.militar});

  factory EscalaExtra.fromJson(Map<String, dynamic> j) => EscalaExtra(
      id: j['id'],
      militar: Militar.fromJson(j['militar'])
  );

  Map<String, dynamic> toJson() => {
    'militar': militar.toJson(),
  };

}