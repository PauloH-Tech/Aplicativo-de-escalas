import 'package:sistema_escalas_front/models/usuario.dart';

/// Acesso ao app de um militar (usuário cadastrado pelo admin).
class AcessoUsuario {
  final String id;
  final String? nome;
  final String email;
  final Role role;
  final bool ativo;
  final bool primeiroAcessoPendente;
  final String? militarId;

  AcessoUsuario({
    required this.id,
    this.nome,
    required this.email,
    required this.role,
    required this.ativo,
    required this.primeiroAcessoPendente,
    this.militarId,
  });

  bool get isAdmin => role == Role.admin;

  factory AcessoUsuario.fromJson(Map<String, dynamic> j) => AcessoUsuario(
    id: j['id'],
    nome: j['nome'],
    email: j['email'],
    role: Role.fromString(j['role']),
    ativo: j['ativo'] ?? false,
    primeiroAcessoPendente: j['primeiroAcessoPendente'] ?? false,
    militarId: j['militarId'],
  );
}
