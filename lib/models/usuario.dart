class Usuario {
  final String nome;
  final Role role;
  final String token;
  final String? militarId;
  final String tipo;

  Usuario({
    required this.nome,
    required this.role,
    required this.token,
    this.militarId,
    required this.tipo,
  });

  bool get isAdmin => role == Role.admin;

  factory Usuario.fromJson(Map<String, dynamic> j) => Usuario(
    nome: j['nome'],
    role: Role.fromString(j['role']),
    token: j['token'],
    militarId: j['militarId'],
    tipo: j['tipo'],
  );

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'role': role.name,
    'token': token,
    'tipo': tipo,
  };
}

enum Role {
  admin,
  user;

  static Role fromString(String valor) {
    final v = valor.toUpperCase().replaceFirst('ROLE_', '');
    return switch (v) {
      'ADMIN' => Role.admin,
      'USER' => Role.user,
      _ => throw ArgumentError('Role desconhecida: $valor'),
    };
  }
}
