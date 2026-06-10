import 'date_activity.dart';

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
  final String? updatedAt;
  final String? url1;
  final String? url2;
  final String? url3;
  final int? availableSpaces;
  final int idProject;
  final String conditions;
  final String observations;
  final String aim;
  final List<DateActivity> fechas;

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
    this.updatedAt,
    this.url1,
    this.url2,
    this.url3,
    this.availableSpaces,
    required this.idProject,
    required this.conditions,
    required this.observations,
    required this.aim,
    this.fechas = const [],
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
      updatedAt: json['UpdatedAt'],
      url1: json['url1'],
      url2: json['url2'],
      url3: json['url3'],
      availableSpaces: json['Available_spaces'],
      idProject: json['Id_project'] ?? json['id_project'] ?? 0,
      conditions: json['Conditions'] ?? '',
      observations: json['Observations'] ?? '',
      aim: json['Aim'] ?? '',
      fechas: (json['fechas'] as List?)?.map((f) => DateActivity.fromJson(f)).toList() ?? [],
    );
  }

  bool get isRecurringBool => isRecurring == 1;
  bool get isFavoriteBool => isFavorite == 1;
  bool get isOpenForRegistrationBool => openForRegistration == 1;
  bool get isActive => activo == 1;

  String get fecha => '';
  int get proyectoId => 0;
  List<int> get voluntariosIds => [];
}
