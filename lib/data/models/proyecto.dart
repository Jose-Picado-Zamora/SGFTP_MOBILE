class Proyecto {
  final int id;
  final String nombre;
  final String slug;
  final String estado;
  final String descripcion;
  final String observaciones;
  final String objetivo;
  final String fechaInicio;
  final String? fechaFin;
  final String poblacionObjetivo;
  final String ubicacion;
  final int activo;

  Proyecto({
    required this.id,
    required this.nombre,
    required this.slug,
    required this.estado,
    required this.descripcion,
    required this.observaciones,
    required this.objetivo,
    required this.fechaInicio,
    this.fechaFin,
    required this.poblacionObjetivo,
    required this.ubicacion,
    required this.activo,
  });

  factory Proyecto.fromJson(Map<String, dynamic> json) {
    return Proyecto(
      id: json['Id_project'] ?? json['id'],
      nombre: json['Name'] ?? json['nombre'],
      slug: json['Slug'] ?? json['slug'] ?? '',
      estado: json['Status'] ?? 'pending',
      descripcion: json['Description'] ?? json['descripcion'] ?? '',
      observaciones: json['Observations'] ?? json['observations'] ?? '',
      objetivo: json['Aim'] ?? json['aim'] ?? '',
      fechaInicio: json['Start_date'] ?? json['fecha_inicio'] ?? '',
      fechaFin: json['End_date'] ?? json['fecha_fin_estimada'],
      poblacionObjetivo: json['Target_population'] ?? '',
      ubicacion: json['Location'] ?? '',
      activo: json['Active'] ?? 1,
    );
  }

  bool get isActive => activo == 1;
  bool get isFinished => estado == 'finished';

  // Compatibilidad con código existente
  String get fechaFinEstimada => fechaFin ?? '';
  String get responsable => '';
  int get progreso => 65; // valor por defecto para compatibilidad
}
