class Proyecto {
  final int id;
  final String nombre;
  final String estado;
  final String descripcion;
  final String fechaInicio;
  final String fechaFinEstimada;
  final String responsable;
  final int progreso;
  final List<int> actividadesIds;

  Proyecto({
    required this.id,
    required this.nombre,
    required this.estado,
    required this.descripcion,
    required this.fechaInicio,
    required this.fechaFinEstimada,
    required this.responsable,
    required this.progreso,
    required this.actividadesIds,
  });

  factory Proyecto.fromJson(Map<String, dynamic> json) {
    return Proyecto(
      id: json['id'],
      nombre: json['nombre'],
      estado: json['estado'],
      descripcion: json['descripcion'],
      fechaInicio: json['fecha_inicio'],
      fechaFinEstimada: json['fecha_fin_estimada'],
      responsable: json['responsable'],
      progreso: json['progreso'],
      actividadesIds: List<int>.from(json['actividades']),
    );
  }
}
