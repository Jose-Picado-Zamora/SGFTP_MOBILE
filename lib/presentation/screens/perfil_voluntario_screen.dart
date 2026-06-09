import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/voluntario.dart';
import '../../data/models/actividad.dart';
import '../../data/repositories/sgftp_repository.dart';
import '../widgets/common_widgets.dart';
import '../../theme/app_theme.dart';

class PerfilVoluntarioScreen extends StatefulWidget {
  final int voluntarioId;
  const PerfilVoluntarioScreen({super.key, required this.voluntarioId});

  @override
  State<PerfilVoluntarioScreen> createState() =>
      _PerfilVoluntarioScreenState();
}

class _PerfilVoluntarioScreenState extends State<PerfilVoluntarioScreen> {
  Voluntario? _voluntario;
  List<Actividad> _actividades = [];
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
      final v = await repo.getVoluntario(widget.voluntarioId);
      final as_ = await repo.getActividadesByVoluntarioId(widget.voluntarioId);
      setState(() {
        _voluntario = v;
        _actividades = as_;
        _loading = false;
      });
    } catch (e) {
      setState(() { _error = 'No se pudo cargar el voluntario.'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil de Voluntario')),
      body: _loading
          ? const LoadingCenter()
          : _error != null
              ? ErrorCenter(_error!, onRetry: _cargar)
              : _buildBody(),
    );
  }

  Widget _buildBody() {
    final v = _voluntario!;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: kPrimary,
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
            child: Column(
              children: [
                AvatarIniciales(v.iniciales, radius: 38),
                const SizedBox(height: 12),
                Text(v.nombre,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                EstadoBadge(v.estado),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Seccion(
                  titulo: 'Información de contacto',
                  child: Column(
                    children: [
                      _InfoRow(Icons.badge_outlined, 'ID de Voluntario', v.cedula),
                      const Divider(height: 16),
                      _InfoRow(Icons.email_outlined, 'Correo', v.correo),
                      const Divider(height: 16),
                      _InfoRow(Icons.phone_outlined, 'Teléfono', v.telefono),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                _Seccion(
                  titulo: 'Actividades participadas (${_actividades.length})',
                  child: _actividades.isEmpty
                      ? const Text('Sin actividades',
                          style: TextStyle(color: Colors.grey))
                      : Column(
                          children: _actividades
                              .map((a) => _ActividadMini(a))
                              .toList(),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String valor;
  const _InfoRow(this.icon, this.label, this.valor);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: kPrimary),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
            Text(valor,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}

class _ActividadMini extends StatelessWidget {
  final Actividad a;
  const _ActividadMini(this.a);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/actividades/${a.id}'),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(Icons.task_outlined, size: 16, color: kSecondary),
            const SizedBox(width: 10),
            Expanded(
                child: Text(a.nombre, style: const TextStyle(fontSize: 13))),
            EstadoBadge(a.estado),
          ],
        ),
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
