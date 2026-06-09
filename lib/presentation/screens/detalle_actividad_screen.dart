import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/actividad.dart';
import '../../data/models/voluntario.dart';
import '../../data/repositories/sgftp_repository.dart';
import '../widgets/common_widgets.dart';
import '../../theme/app_theme.dart';

class DetalleActividadScreen extends StatefulWidget {
  final int actividadId;
  const DetalleActividadScreen({super.key, required this.actividadId});

  @override
  State<DetalleActividadScreen> createState() =>
      _DetalleActividadScreenState();
}

class _DetalleActividadScreenState extends State<DetalleActividadScreen> {
  Actividad? _actividad;
  List<Voluntario> _voluntarios = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() { _loading = true; _error = null; });
    try {
      final repo = SgftpRepository.instance;
      final a = await repo.getActividad(widget.actividadId);
      final vs = await repo.getVoluntariosByIds(a.voluntariosIds);
      setState(() {
        _actividad = a;
        _voluntarios = vs;
        _loading = false;
      });
    } catch (e) {
      setState(() { _error = 'No se pudo cargar la actividad.'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Actividad')),
      body: _loading
          ? const LoadingCenter()
          : _error != null
              ? ErrorCenter(_error!, onRetry: _cargar)
              : _buildBody(),
    );
  }

  Widget _buildBody() {
    final a = _actividad!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: estadoColor(a.estado).withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: estadoColor(a.estado).withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EstadoBadge(a.estado),
                const SizedBox(height: 10),
                Text(a.nombre,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(a.fecha,
                        style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _Seccion(
            titulo: 'Descripción',
            child: Text(a.descripcion,
                style: const TextStyle(fontSize: 14, height: 1.5)),
          ),
          const SizedBox(height: 16),

          _Seccion(
            titulo: 'Voluntarios asignados (${_voluntarios.length})',
            child: _voluntarios.isEmpty
                ? const Text('Sin voluntarios asignados',
                    style: TextStyle(color: Colors.grey))
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _voluntarios
                        .map((v) => ActionChip(
                              avatar: AvatarIniciales(v.iniciales, radius: 12),
                              label: Text(v.nombre.split(' ').first,
                                  style: const TextStyle(fontSize: 13)),
                              onPressed: () =>
                                  context.push('/voluntarios/${v.id}'),
                            ))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class _Seccion extends StatelessWidget {
  final String titulo;
  final Widget child;
  const _Seccion({required this.titulo, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.5)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
