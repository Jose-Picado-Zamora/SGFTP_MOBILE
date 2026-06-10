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
  final String fechaRegistro;
  final String fechaActualizacion;
  final String poblacionObjetivo;
  final String ubicacion;
  final int activo;
  final int metricTotalBeneficiated;
  final int metricTotalWasteCollected;
  final int metricTotalTreesPlanted;
  final String? url1;
  final String? url2;
  final String? url3;
  final String? url4;
  final String? url5;
  final String? url6;

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
    required this.fechaRegistro,
    required this.fechaActualizacion,
    required this.poblacionObjetivo,
    required this.ubicacion,
    required this.activo,
    required this.metricTotalBeneficiated,
    required this.metricTotalWasteCollected,
    required this.metricTotalTreesPlanted,
    this.url1,
    this.url2,
    this.url3,
    this.url4,
    this.url5,
    this.url6,
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
      fechaRegistro: json['Registration_date'] ?? DateTime.now().toString(),
      fechaActualizacion: json['UpdatedAt'] ?? DateTime.now().toString(),
      poblacionObjetivo: json['Target_population'] ?? '',
      ubicacion: json['Location'] ?? '',
      activo: json['Active'] ?? 1,
      metricTotalBeneficiated: json['METRIC_TOTAL_BENEFICIATED'] ?? 0,
      metricTotalWasteCollected: json['METRIC_TOTAL_WASTE_COLLECTED'] ?? 0,
      metricTotalTreesPlanted: json['METRIC_TOTAL_TREES_PLANTED'] ?? 0,
      url1: json['url_1'],
      url2: json['url_2'],
      url3: json['url_3'],
      url4: json['url_4'],
      url5: json['url_5'],
      url6: json['url_6'],
    );
  }

  bool get isActive => activo == 1;
  bool get isFinished => estado == 'finished';

  String get fechaFinEstimada => fechaFin ?? '';
  String get responsable => '';
  int get progreso => 65; // valor por defecto para compatibilidad
}
