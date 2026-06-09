class Voluntario {
  final int id;
  final String nombre;
  final String cedula;
  final String estado;
  final String correo;
  final String telefono;
  final List<int> proyectosIds;
  final List<int> actividadesIds;

  Voluntario({
    required this.id,
    required this.nombre,
    required this.cedula,
    required this.estado,
    required this.correo,
    required this.telefono,
    required this.proyectosIds,
    required this.actividadesIds,
  });

  factory Voluntario.fromJson(Map<String, dynamic> json) {
    return Voluntario(
      id: json['id_volunteer'] ?? json['id'],
      nombre: json['nombre'] ?? '',
      cedula: json['cedula'] ?? '',
      estado: json['estado'] ?? 'Activo',
      correo: json['correo'] ?? json['email'] ?? '',
      telefono: json['telefono'] ?? json['phone_primary'] ?? '',
      proyectosIds: json['proyectos_ids'] != null
          ? List<int>.from(json['proyectos_ids'])
          : [],
      actividadesIds: json['actividades_ids'] != null
          ? List<int>.from(json['actividades_ids'])
          : [],
    );
  }

  String get iniciales {
    final parts = nombre.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}';
    return parts[0][0];
  }
}
