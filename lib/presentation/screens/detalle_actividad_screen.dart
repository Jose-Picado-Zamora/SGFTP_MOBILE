import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/actividad.dart';
import '../../data/models/voluntario.dart';
import '../../data/repositories/sgftp_repository.dart';
import '../widgets/common_widgets.dart';
import '../../theme/app_theme.dart';
import '../../utils/date_formatter.dart';

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
      final vs = await repo.getVoluntariosByActividadId(widget.actividadId);
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
                if (a.fechas.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            formatearRangoFechas(a.fechas.first.startDate, a.fechas.first.endDate),
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                      if (a.fechas.length > 1) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${a.fechas.length} fechas programadas',
                          style: const TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                      ],
                    ],
                  )
                else
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text('Sin fechas programadas',
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
            titulo: 'Objetivo',
            child: Text(a.aim,
                style: const TextStyle(fontSize: 14, height: 1.5)),
          ),
          const SizedBox(height: 16),

          _Seccion(
            titulo: 'Detalles de la actividad',
            child: Column(
              children: [
                _DetalleItem(Icons.category_outlined, 'Tipo', a.tipo),
                const Divider(height: 16),
                _DetalleItem(Icons.psychology_outlined, 'Enfoque', a.enfoque),
                const Divider(height: 16),
                _DetalleItem(Icons.location_on_outlined, 'Ubicación', a.ubicacion),
                const Divider(height: 16),
                _DetalleItem(Icons.people_outline, 'Espacios totales', '${a.espacios}'),
                const Divider(height: 16),
                _DetalleItem(Icons.how_to_reg_outlined, 'Inscritos', '${a.enrolledCount}'),
                if (a.availableSpaces != null) ...[
                  const Divider(height: 16),
                  _DetalleItem(Icons.event_seat_outlined, 'Espacios disponibles', '${a.availableSpaces}'),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (a.metricActivity != null && a.totalMetricValue != null)
            _Seccion(
              titulo: 'Métrica de la actividad',
              child: Row(
                children: [
                  const Icon(Icons.bar_chart_outlined, size: 20, color: kPrimary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a.metricActivity!,
                            style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        Text('${a.totalMetricValue}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),

          if (a.conditions.isNotEmpty)
            _Seccion(
              titulo: 'Condiciones',
              child: Text(a.conditions,
                  style: const TextStyle(fontSize: 14, height: 1.5)),
            ),
          const SizedBox(height: 16),

          if (a.observations.isNotEmpty)
            _Seccion(
              titulo: 'Observaciones',
              child: Text(a.observations,
                  style: const TextStyle(fontSize: 14, height: 1.5)),
            ),
          const SizedBox(height: 16),

          _Seccion(
            titulo: 'Imágenes de la actividad',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (a.url1 != null) _ImageItem(a.url1!)
                else _ImageItem('https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&q=80'),
                if (a.url2 != null) _ImageItem(a.url2!),
                if (a.url3 != null) _ImageItem(a.url3!),
              ],
            ),
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

class _DetalleItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String valor;
  const _DetalleItem(this.icon, this.label, this.valor);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: kPrimary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 11, color: Colors.grey)),
              Text(valor,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ImageItem extends StatelessWidget {
  final String url;
  const _ImageItem(this.url);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        url,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.broken_image, color: Colors.grey),
          );
        },
      ),
    );
  }
}
