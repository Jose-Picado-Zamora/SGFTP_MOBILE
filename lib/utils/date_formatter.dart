import 'package:intl/intl.dart';

String formatearFecha(String fecha) {
  if (fecha.isEmpty) return '';
  try {
    final dt = DateTime.parse(fecha);
    return DateFormat('dd MMMM yyyy', 'es_ES').format(dt);
  } catch (e) {
    // Si falla, intentar formato sin milisegundos
    try {
      final dt = DateTime.parse(fecha.split('.')[0]);
      return DateFormat('dd MMMM yyyy', 'es_ES').format(dt);
    } catch (e2) {
      return fecha;
    }
  }
}

String formatearFechaHora(String fecha) {
  if (fecha.isEmpty) return '';
  try {
    final dt = DateTime.parse(fecha);
    return DateFormat('dd MMMM yyyy, HH:mm', 'es_ES').format(dt);
  } catch (e) {
    // Si falla, intentar formato sin milisegundos
    try {
      final dt = DateTime.parse(fecha.split('.')[0]);
      return DateFormat('dd MMMM yyyy, HH:mm', 'es_ES').format(dt);
    } catch (e2) {
      return fecha;
    }
  }
}

String formatearFechaCorta(String fecha) {
  if (fecha.isEmpty) return '';
  try {
    final dt = DateTime.parse(fecha);
    return DateFormat('dd/MM/yy', 'es_ES').format(dt);
  } catch (e) {
    // Si falla, intentar formato sin milisegundos
    try {
      final dt = DateTime.parse(fecha.split('.')[0]);
      return DateFormat('dd/MM/yy', 'es_ES').format(dt);
    } catch (e2) {
      return fecha;
    }
  }
}

String formatearHora(String fecha) {
  if (fecha.isEmpty) return '';
  try {
    final dt = DateTime.parse(fecha);
    return DateFormat('HH:mm', 'es_ES').format(dt);
  } catch (e) {
    // Si falla, intentar formato sin milisegundos
    try {
      final dt = DateTime.parse(fecha.split('.')[0]);
      return DateFormat('HH:mm', 'es_ES').format(dt);
    } catch (e2) {
      return fecha;
    }
  }
}

String formatearRangoFechas(String startDate, String endDate) {
  if (startDate.isEmpty) return '';
  try {
    final start = DateTime.parse(startDate);
    final formattedStart = DateFormat('dd MMMM, HH:mm', 'es_ES').format(start);
    
    if (endDate.isEmpty) {
      return formattedStart;
    }
    
    final end = DateTime.parse(endDate);
    final formattedEnd = DateFormat('dd MMMM, HH:mm', 'es_ES').format(end);
    
    // Si es el mismo día
    if (start.year == end.year && start.month == end.month && start.day == end.day) {
      return '${DateFormat('dd MMMM', 'es_ES').format(start)}: ${DateFormat('HH:mm', 'es_ES').format(start)} - ${DateFormat('HH:mm', 'es_ES').format(end)}';
    }
    
    return '$formattedStart - $formattedEnd';
  } catch (e) {
    // Si falla, intentar formato sin milisegundos
    try {
      final start = DateTime.parse(startDate.split('.')[0]);
      final formattedStart = DateFormat('dd MMMM, HH:mm', 'es_ES').format(start);
      
      if (endDate.isEmpty) {
        return formattedStart;
      }
      
      final end = DateTime.parse(endDate.split('.')[0]);
      final formattedEnd = DateFormat('dd MMMM, HH:mm', 'es_ES').format(end);
      
      if (start.year == end.year && start.month == end.month && start.day == end.day) {
        return '${DateFormat('dd MMMM', 'es_ES').format(start)}: ${DateFormat('HH:mm', 'es_ES').format(start)} - ${DateFormat('HH:mm', 'es_ES').format(end)}';
      }
      
      return '$formattedStart - $formattedEnd';
    } catch (e2) {
      return startDate;
    }
  }
}
