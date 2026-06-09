class Actividad {
  final int id;
  final String nombre;
  final String descripcion;
  final int isRecurring;
  final int isFavorite;
  final int openForRegistration;
  final String estado;
  final String tipo;
  final String enfoque;
  final String ubicacion;
  final int espacios;
  final int activo;
  final int enrolledCount;
  final String? metricActivity;
  final int? totalMetricValue;
  final String? registrationDate;

  Actividad({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.isRecurring,
    required this.isFavorite,
    required this.openForRegistration,
    required this.estado,
    required this.tipo,
    required this.enfoque,
    required this.ubicacion,
    required this.espacios,
    required this.activo,
    this.enrolledCount = 0,
    this.metricActivity,
    this.totalMetricValue,
    this.registrationDate,
  });

  factory Actividad.fromJson(Map<String, dynamic> json) {
    return Actividad(
      id: json['Id_activity'] ?? json['id_activity'] ?? json['id'] ?? 0,
      nombre: json['Name'] ?? json['name'] ?? json['nombre'] ?? '',
      descripcion: json['Description'] ?? json['description'] ?? json['descripcion'] ?? '',
      isRecurring: json['IsRecurring'] ?? json['is_recurring'] ?? 0,
      isFavorite: json['IsFavorite'] != null ? (json['IsFavorite'] is String ? (json['IsFavorite'] == '1' ? 1 : 0) : json['IsFavorite']) : 0,
      openForRegistration: json['OpenForRegistration'] ?? json['open_for_registration'] ?? 0,
      estado: json['Status_activity'] ?? json['estado'] ?? 'pending',
      tipo: json['Type_activity'] ?? json['type'] ?? '',
      enfoque: json['Approach'] ?? json['approach'] ?? '',
      ubicacion: json['Location'] ?? json['ubicacion'] ?? '',
      espacios: json['Spaces'] ?? 0,
      activo: json['Active'] ?? 1,
      enrolledCount: json['Enrolled_count'] ?? 0,
      metricActivity: json['Metric_activity'],
      totalMetricValue: json['Total_metric_value'],
      registrationDate: json['Registration_date'],
    );
  }

  bool get isRecurringBool => isRecurring == 1;
  bool get isFavoriteBool => isFavorite == 1;
  bool get isOpenForRegistrationBool => openForRegistration == 1;
  bool get isActive => activo == 1;

  // Compatibilidad con código existente
  String get fecha => '';
  int get proyectoId => 0;
  List<int> get voluntariosIds => [];
}
