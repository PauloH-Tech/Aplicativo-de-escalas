class EscalaExtraRequest {
  final String rodadaId;
  final List<String> militarIds;

  EscalaExtraRequest({required this.rodadaId, required this.militarIds});

  Map<String, dynamic> toJson() => {
    'rodadaId': rodadaId,
    'militarIds': militarIds
  };


}