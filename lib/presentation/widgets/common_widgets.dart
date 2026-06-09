import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class EstadoBadge extends StatelessWidget {
  final String estado;
  const EstadoBadge(this.estado, {super.key});

  @override
  Widget build(BuildContext context) {
    final traducido = traductorEstado(estado);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: estadoColor(estado).withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: estadoColor(estado), width: 1),
      ),
      child: Text(
        traducido,
        style: TextStyle(
          color: estadoColor(estado),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class AvatarIniciales extends StatelessWidget {
  final String iniciales;
  final double radius;
  const AvatarIniciales(this.iniciales, {super.key, this.radius = 22});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: kPrimary,
      child: Text(
        iniciales,
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.7,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class LoadingCenter extends StatelessWidget {
  const LoadingCenter({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class ErrorCenter extends StatelessWidget {
  final String mensaje;
  final VoidCallback? onRetry;
  const ErrorCenter(this.mensaje, {super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(mensaje, textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey)),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class BarraProgreso extends StatelessWidget {
  final int progreso;
  const BarraProgreso(this.progreso, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Progreso', style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text('$progreso%',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progreso / 100,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
          ),
        ),
      ],
    );
  }
}