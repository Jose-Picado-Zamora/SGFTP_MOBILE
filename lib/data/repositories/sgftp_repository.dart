import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/proyecto.dart';
import '../models/actividad.dart';
import '../models/voluntario.dart';

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
    List<Proyecto> lista = (_db!['proyectos'] as List)
        .map((j) => Proyecto.fromJson(j))
        .toList();
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
    final json = (_db!['proyectos'] as List).firstWhere((j) => j['id'] == id);
    return Proyecto.fromJson(json);
  }

  Future<List<Actividad>> getActividades(int proyectoId,
      {String? estado, DateTime? desde, DateTime? hasta}) async {
    await _ensureLoaded();
    List<Actividad> lista = (_db!['actividades'] as List)
        .map((j) => Actividad.fromJson(j))
        .where((a) => a.proyectoId == proyectoId)
        .toList();
    if (estado != null && estado != 'Todas') {
      lista = lista.where((a) => a.estado == estado).toList();
    }
    if (desde != null) {
      lista = lista
          .where((a) => !DateTime.parse(a.fecha).isBefore(desde))
          .toList();
    }
    if (hasta != null) {
      lista = lista
          .where((a) => !DateTime.parse(a.fecha).isAfter(hasta))
          .toList();
    }
    return lista;
  }

  Future<Actividad> getActividad(int id) async {
    await _ensureLoaded();
    final json = (_db!['actividades'] as List).firstWhere((j) => j['id'] == id);
    return Actividad.fromJson(json);
  }

  Future<List<Voluntario>> getVoluntarios({String? query}) async {
    await _ensureLoaded();
    List<Voluntario> lista = (_db!['voluntarios'] as List)
        .map((j) => Voluntario.fromJson(j))
        .toList();
    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      lista = lista
          .where((v) =>
              v.nombre.toLowerCase().contains(q) || v.cedula.contains(q))
          .toList();
    }
    return lista;
  }

  Future<Voluntario> getVoluntario(int id) async {
    await _ensureLoaded();
    final json = (_db!['voluntarios'] as List).firstWhere((j) => j['id'] == id);
    return Voluntario.fromJson(json);
  }

  Future<List<Voluntario>> getVoluntariosByIds(List<int> ids) async {
    await _ensureLoaded();
    return (_db!['voluntarios'] as List)
        .where((j) => ids.contains(j['id']))
        .map((j) => Voluntario.fromJson(j))
        .toList();
  }

  Future<List<Proyecto>> getProyectosByIds(List<int> ids) async {
    await _ensureLoaded();
    return (_db!['proyectos'] as List)
        .where((j) => ids.contains(j['id']))
        .map((j) => Proyecto.fromJson(j))
        .toList();
  }

  Future<List<Actividad>> getActividadesByIds(List<int> ids) async {
    await _ensureLoaded();
    return (_db!['actividades'] as List)
        .where((j) => ids.contains(j['id']))
        .map((j) => Actividad.fromJson(j))
        .toList();
  }
}
