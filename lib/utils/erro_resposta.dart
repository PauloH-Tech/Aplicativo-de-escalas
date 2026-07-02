class ErroResposta {
  final int status;
  final String mensagem;

  ErroResposta({required this.status, required this.mensagem});

  factory ErroResposta.fromJson(Map<String, dynamic> json) {
    return ErroResposta(status: json['status'], mensagem: json['mensagem']);
  }
}
