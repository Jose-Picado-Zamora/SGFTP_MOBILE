import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'presentation/screens/dashboard_screen.dart';
import 'presentation/screens/lista_proyectos_screen.dart';
import 'presentation/screens/detalle_proyecto_screen.dart';
import 'presentation/screens/lista_actividades_screen.dart';
import 'presentation/screens/detalle_actividad_screen.dart';
import 'presentation/screens/lista_voluntarios_screen.dart';
import 'presentation/screens/perfil_voluntario_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/proyectos',
      builder: (_, __) => const ListaProyectosScreen(),
    ),
    GoRoute(
      path: '/proyectos/:id',
      builder: (_, state) => DetalleProyectoScreen(
        proyectoId: int.parse(state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: '/proyectos/:id/actividades',
      builder: (_, state) => ListaActividadesScreen(
        proyectoId: int.parse(state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: '/actividades/:id',
      builder: (_, state) => DetalleActividadScreen(
        actividadId: int.parse(state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: '/voluntarios',
      builder: (_, __) => const ListaVoluntariosScreen(),
    ),
    GoRoute(
      path: '/voluntarios/:id',
      builder: (_, state) => PerfilVoluntarioScreen(
        voluntarioId: int.parse(state.pathParameters['id']!),
      ),
    ),
  ],
  errorBuilder: (_, state) => Scaffold(
    body: Center(child: Text('Ruta no encontrada: ${state.uri}')),
  ),
);
