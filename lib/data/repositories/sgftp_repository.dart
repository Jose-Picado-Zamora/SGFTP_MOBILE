import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/proyecto.dart';
import '../models/actividad.dart';
import '../models/voluntario.dart';
import '../models/date_activity.dart';

class SgftpRepository {
  static SgftpRepository? _instance;
  static SgftpRepository get instance => _instance ??= SgftpRepository._();
  SgftpRepository._();

  Map<String, dynamic>? _db;

  Future<void> _ensureLoaded() async {
    if (_db != null) return;
    await Future.delayed(const Duration(milliseconds: 600));
    final raw = await rootBundle.loadString('assets/data/db.json');
    _db = jsonDecode(raw);
  }

  Future<List<Proyecto>> getProyectos({String? estado, String? nombre}) async {
    await _ensureLoaded();
    List<Proyecto> lista = (_db!['project'] as List?)?.map((j) => Proyecto.fromJson(j)).toList() ?? [];
    if (estado != null && estado != 'Todos') {
      lista = lista.where((p) => p.estado == estado).toList();
    }
    if (nombre != null && nombre.isNotEmpty) {
      final q = nombre.toLowerCase();
      lista = lista.where((p) => p.nombre.toLowerCase().contains(q)).toList();
    }
    return lista;
  }

  Future<Proyecto> getProyecto(int id) async {
    await _ensureLoaded();
    final json = (_db!['project'] as List).firstWhere((j) => j['Id_project'] == id);
    return Proyecto.fromJson(json);
  }

  int _realEnrolledCount(int actividadId) {
    return (_db!['activity_enrollment'] as List?)?.where((e) => e['id_activity'] == actividadId).length ?? 0;
  }

  Future<List<Actividad>> getActividades(int proyectoId,
      {String? estado, DateTime? desde, DateTime? hasta}) async {
    await _ensureLoaded();
    List<Actividad> lista = (_db!['activity'] as List?)?.map((j) {
      j['Enrolled_count'] = _realEnrolledCount(j['Id_activity']);
      return Actividad.fromJson(j);
    }).toList() ?? [];
    if (estado != null && estado != 'Todas') {
      lista = lista.where((a) => a.estado == estado).toList();
    }
    return lista;
  }

  Future<Actividad> getActividad(int id) async {
    await _ensureLoaded();
    final json = (_db!['activity'] as List).firstWhere((j) => j['Id_activity'] == id);
    json['Enrolled_count'] = _realEnrolledCount(id);
    final fechas = await getDateActivitiesByActividadId(id);
    json['fechas'] = fechas.map((f) => f.toJson()).toList();
    return Actividad.fromJson(json);
  }

  Future<List<DateActivity>> getDateActivitiesByActividadId(int actividadId) async {
    await _ensureLoaded();
    return (_db!['date_activity'] as List?)?.where((j) => j['Id_activity'] == actividadId)
        .map((j) => DateActivity.fromJson(j))
        .toList() ?? [];
  }

  Future<List<Voluntario>> getVoluntarios({String? query}) async {
    await _ensureLoaded();
    List<Voluntario> lista = (_db!['volunteers'] as List?)?.map((j) {
      _enrichVolunteerData(j);
      return Voluntario.fromJson(j);
    }).toList() ?? [];
    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      lista = lista
          .where((v) =>
              v.nombre.toLowerCase().contains(q) || v.email.contains(q))
          .toList();
    }
    return lista;
  }

  Future<Voluntario> getVoluntario(int id) async {
    await _ensureLoaded();
    final json = (_db!['volunteers'] as List).firstWhere((j) => j['id_volunteer'] == id);
    _enrichVolunteerData(json);
    return Voluntario.fromJson(json);
  }

  void _enrichVolunteerData(Map<String, dynamic> volunteer) {
    final person = _getPersonById(volunteer['id_person']);
    if (person != null) {
      volunteer['nombre'] = '${person['first_name']} ${person['first_lastname']}';
      volunteer['email'] = person['email'];
      volunteer['phone_primary'] = person['phone_primary'];
      volunteer['phone_secondary'] = person['phone_secondary'];
    }
  }

  Map<String, dynamic>? _getPersonById(int id) {
    try {
      return (_db!['person'] as List?)?.firstWhere((p) => p['id_person'] == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Voluntario>> getVoluntariosByActividadId(int actividadId) async {
    await _ensureLoaded();
    final enrollments = (_db!['activity_enrollment'] as List?)?.where((e) => e['id_activity'] == actividadId).toList() ?? [];
    final voluntarioIds = enrollments.map((e) => e['id_volunteer'] as int).toList();
    return getVoluntariosByIds(voluntarioIds);
  }

  Future<List<Voluntario>> getVoluntariosByIds(List<int> ids) async {
    await _ensureLoaded();
    return (_db!['volunteers'] as List?)?.where((j) => ids.contains(j['id_volunteer']))
        .map((j) {
          _enrichVolunteerData(j);
          return Voluntario.fromJson(j);
        })
        .toList() ?? [];
  }

  Future<List<Proyecto>> getProyectosByIds(List<int> ids) async {
    await _ensureLoaded();
    return (_db!['project'] as List?)?.where((j) => ids.contains(j['Id_project']))
        .map((j) => Proyecto.fromJson(j))
        .toList() ?? [];
  }

  Future<List<Actividad>> getActividadesByVoluntarioId(int voluntarioId) async {
    await _ensureLoaded();
    final enrollments = (_db!['activity_enrollment'] as List?)?.where((e) => e['id_volunteer'] == voluntarioId).toList() ?? [];
    final activityIds = enrollments.map((e) => e['id_activity'] as int).toList();
    return getActividadesByIds(activityIds);
  }

  Future<List<Actividad>> getActividadesByIds(List<int> ids) async {
    await _ensureLoaded();
    return (_db!['activity'] as List?)?.where((j) => ids.contains(j['Id_activity']))
        .map((j) {
          j['Enrolled_count'] = _realEnrolledCount(j['Id_activity']);
          return Actividad.fromJson(j);
        })
        .toList() ?? [];
  }
}
