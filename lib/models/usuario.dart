class Usuario {
  final String nome;
  final Role role;
  final String token;
  final String? militarId;

  Usuario({
    required this.nome,
    required this.role,
    required this.token,
    this.militarId,
  });

  bool get isAdmin => role == Role.admin;

  factory Usuario.fromJson(Map<String, dynamic> j) => Usuario(
    nome: j['nome'],
    role: Role.fromString(j['role']),
    token: j['token'],
    militarId: j['militarId']
  );

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'role': role.name,
    'token': token,
    'militarId': militarId
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
