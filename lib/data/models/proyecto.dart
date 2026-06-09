class Proyecto {
  final int id;
  final String nombre;
  final String estado;
  final String descripcion;
  final String fechaInicio;
  final String fechaFinEstimada;
  final String responsable;
  final int progreso;

  Proyecto({
    required this.id,
    required this.nombre,
    required this.estado,
    required this.descripcion,
    required this.fechaInicio,
    required this.fechaFinEstimada,
    required this.responsable,
    required this.progreso,
  });

  factory Proyecto.fromJson(Map<String, dynamic> json) {
    return Proyecto(
      id: json['id_project'] ?? json['id'],
      nombre: json['name'] ?? json['nombre'],
      estado: json['estado'] ?? 'Activo',
      descripcion: json['description'] ?? json['descripcion'],
      fechaInicio: json['start_date'] ?? json['fecha_inicio'],
      fechaFinEstimada: json['fecha_fin_estimada'] ?? '',
      responsable: json['responsable'] ?? '',
      progreso: json['progreso'] ?? 0,
    );
  }
}
