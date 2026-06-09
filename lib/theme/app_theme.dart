import 'package:flutter/material.dart';

const Color kPrimary = Color(0xFF1A237E);
const Color kSecondary = Color(0xFF00897B);

ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: kPrimary,
    secondary: kSecondary,
    brightness: Brightness.light,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    appBarTheme: AppBarTheme(
      backgroundColor: kPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}

// Colores de estado
Color estadoColor(String estado) {
  switch (estado) {
    case 'Activo':
    case 'En curso':
      return const Color(0xFF2E7D32);
    case 'Inactivo':
    case 'Pendiente':
      return const Color(0xFFE65100);
    case 'Completado':
    case 'Completada':
      return const Color(0xFF1565C0);
    default:
      return Colors.grey;
  }
}
