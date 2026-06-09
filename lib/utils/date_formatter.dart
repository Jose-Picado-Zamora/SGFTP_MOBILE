import 'package:intl/intl.dart';

String formatearFecha(String fecha) {
  if (fecha.isEmpty) return '';
  try {
    final dt = DateTime.parse(fecha);
    return DateFormat('dd MMM yyyy', 'es_ES').format(dt);
  } catch (e) {
    return fecha;
  }
}

String formatearFechaHora(String fecha) {
  if (fecha.isEmpty) return '';
  try {
    final dt = DateTime.parse(fecha);
    return DateFormat('dd MMM yyyy, HH:mm', 'es_ES').format(dt);
  } catch (e) {
    return fecha;
  }
}

String formatearFechaCorta(String fecha) {
  if (fecha.isEmpty) return '';
  try {
    final dt = DateTime.parse(fecha);
    return DateFormat('dd/MM/yy', 'es_ES').format(dt);
  } catch (e) {
    return fecha;
  }
}
