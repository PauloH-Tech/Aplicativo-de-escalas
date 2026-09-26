class Usuario {
  final String usuario;
  final Role role;
  final String? token;

  Usuario({required this.usuario, required this.role, this.token});

  bool get isAdmin => role == Role.admin;

  factory Usuario.fromJson(Map<String, dynamic> j) => Usuario(
    usuario: j['usuario'],
    role: Role.fromString(j['role']),
    token: j['token'],
  );

  Map<String, dynamic> toJson() => {
    'usuario': usuario,
    'role': role.name,
    'token': token,
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
