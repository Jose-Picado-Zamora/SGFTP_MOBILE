class Actividad {
  final int id;
  final int proyectoId;
  final String nombre;
  final String estado;
  final String descripcion;
  final String fecha;
  final List<int> voluntariosIds;

  Actividad({
    required this.id,
    required this.proyectoId,
    required this.nombre,
    required this.estado,
    required this.descripcion,
    required this.fecha,
    required this.voluntariosIds,
  });

  factory Actividad.fromJson(Map<String, dynamic> json) {
    return Actividad(
      id: json['id_activity'] ?? json['id'],
      proyectoId: json['proyecto_id'] ?? 0,
      nombre: json['name'] ?? json['nombre'],
      estado: json['estado'] ?? 'Pendiente',
      descripcion: json['description'] ?? json['descripcion'],
      fecha: json['fecha'] ?? DateTime.now().toString(),
      voluntariosIds: json['voluntarios_ids'] != null
          ? List<int>.from(json['voluntarios_ids'])
          : [],
    );
  }
}
