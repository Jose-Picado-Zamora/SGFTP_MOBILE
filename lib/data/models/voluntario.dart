class Voluntario {
  final int id;
  final String nombre;
  final String email;
  final String telefonoPrimario;
  final String? telefonoSecundario;
  final int isActive;
  final String registrationDate;
  final String updatedAt;
  final int idPerson;

  Voluntario({
    required this.id,
    required this.nombre,
    required this.email,
    required this.telefonoPrimario,
    this.telefonoSecundario,
    required this.isActive,
    required this.registrationDate,
    required this.updatedAt,
    required this.idPerson,
  });

  factory Voluntario.fromJson(Map<String, dynamic> json) {
    return Voluntario(
      id: json['id_volunteer'] ?? json['id'] ?? 0,
      nombre: json['nombre'] ?? json['first_name'] ?? '',
      email: json['email'] ?? json['correo'] ?? '',
      telefonoPrimario: json['phone_primary'] ?? json['telefono'] ?? '',
      telefonoSecundario: json['phone_secondary'] ?? json['telefono_secundario'],
      isActive: json['is_active'] ?? 1,
      registrationDate: json['registration_date'] ?? DateTime.now().toString(),
      updatedAt: json['updated_at'] ?? DateTime.now().toString(),
      idPerson: json['id_person'] ?? 0,
    );
  }

  String get iniciales {
    final parts = nombre.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}';
    return parts.isNotEmpty ? parts[0][0] : '?';
  }

  bool get isActiveVolunteer => isActive == 1;

  String get cedula => 'V-$id';
  String get estado => isActive == 1 ? 'Activo' : 'Inactivo';
  String get correo => email;
  String get telefono => telefonoPrimario;
  List<int> get proyectosIds => [];
  List<int> get actividadesIds => [];
}
