class Role {
  final int idRole;
  final String name;

  Role({
    required this.idRole,
    required this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      idRole: json['id_role'],
      name: json['name'],
    );
  }
}
