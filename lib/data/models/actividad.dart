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
      id: json['id'],
      proyectoId: json['proyecto_id'],
      nombre: json['nombre'],
      estado: json['estado'],
      descripcion: json['descripcion'],
      fecha: json['fecha'],
      voluntariosIds: List<int>.from(json['voluntarios_ids']),
    );
  }
}
