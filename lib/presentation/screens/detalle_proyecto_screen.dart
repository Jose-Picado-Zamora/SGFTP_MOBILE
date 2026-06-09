import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/proyecto.dart';
import '../../data/repositories/sgftp_repository.dart';
import '../widgets/common_widgets.dart';
import '../../theme/app_theme.dart';
import '../../utils/date_formatter.dart';

class DetalleProyectoScreen extends StatefulWidget {
  final int proyectoId;
  const DetalleProyectoScreen({super.key, required this.proyectoId});

  @override
  State<DetalleProyectoScreen> createState() =>
      _DetalleProyectoScreenState();
}

class _DetalleProyectoScreenState extends State<DetalleProyectoScreen> {
  Proyecto? _proyecto;
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
      final p = await SgftpRepository.instance.getProyecto(widget.proyectoId);
      setState(() { _proyecto = p; _loading = false; });
    } catch (e) {
      setState(() { _error = 'No se pudo cargar el proyecto.'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Proyecto')),
      body: _loading
          ? const LoadingCenter()
          : _error != null
              ? ErrorCenter(_error!, onRetry: _cargar)
              : _buildBody(),
    );
  }

  Widget _buildBody() {
    final p = _proyecto!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kPrimary, kPrimary.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EstadoBadge(p.estado),
                const SizedBox(height: 12),
                Text(
                  p.nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person_outline,
                        color: Colors.white70, size: 14),
                    const SizedBox(width: 4),
                    Text(p.responsable,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _Seccion(titulo: 'Avance del Proyecto', child: BarraProgreso(p.progreso)),
          const SizedBox(height: 16),

          _Seccion(
            titulo: 'Fechas',
            child: Row(
              children: [
                Expanded(child: _FechaItem('Inicio', formatearFechaHora(p.fechaInicio), Icons.play_circle_outline)),
                Expanded(child: _FechaItem('Fin estimado', p.fechaFin != null ? formatearFechaHora(p.fechaFin!) : 'No definido', Icons.flag_outlined)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          _Seccion(
            titulo: 'Descripción',
            child: Text(
              p.descripcion,
              style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 16),

          _Seccion(
            titulo: 'Objetivo',
            child: Text(
              p.objetivo,
              style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 16),

          _Seccion(
            titulo: 'Observaciones',
            child: Text(
              p.observaciones,
              style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 16),

          _Seccion(
            titulo: 'Ubicación',
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: kPrimary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    p.ubicacion,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          _Seccion(
            titulo: 'Población objetivo',
            child: Text(
              p.poblacionObjetivo,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 16),

          _Seccion(
            titulo: 'Métricas del proyecto',
            child: Column(
              children: [
                _MetricaItem('Personas beneficiadas', '${p.metricTotalBeneficiated}', Icons.people_outline),
                const Divider(height: 24),
                _MetricaItem('Residuos recolectados (kg)', '${p.metricTotalWasteCollected}', Icons.delete_outline),
                const Divider(height: 24),
                _MetricaItem('Árboles plantados', '${p.metricTotalTreesPlanted}', Icons.park_outlined),
              ],
            ),
          ),
          const SizedBox(height: 16),

          _Seccion(
            titulo: 'Imágenes del proyecto',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (p.url1 != null) _ImageItem(p.url1!)
                else _ImageItem('https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&q=80'),
                if (p.url2 != null) _ImageItem(p.url2!),
                if (p.url3 != null) _ImageItem(p.url3!),
              ],
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () =>
                  context.push('/proyectos/${p.id}/actividades'),
              icon: const Icon(Icons.task_alt_rounded),
              label: const Text('Ver actividades del proyecto'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
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

class _FechaItem extends StatelessWidget {
  final String label;
  final String fecha;
  final IconData icon;
  const _FechaItem(this.label, this.fecha, this.icon);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: kPrimary),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style:
                    const TextStyle(fontSize: 11, color: Colors.grey)),
            Text(fecha,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}

class _MetricaItem extends StatelessWidget {
  final String label;
  final String valor;
  final IconData icon;
  const _MetricaItem(this.label, this.valor, this.icon);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: kPrimary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(valor,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
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
