class EscalaExtra {
  final String? id;
  final String militarId;
  final String rodadaId;

  EscalaExtra({this.id, required this.militarId, required this.rodadaId});

  Map<String, dynamic> toJson() => {
    'militarId': militarId,
    'rodadaId': rodadaId,
  };


}