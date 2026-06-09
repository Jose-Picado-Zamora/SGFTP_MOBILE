import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/actividad.dart';
import '../../data/repositories/sgftp_repository.dart';
import '../widgets/common_widgets.dart';
import '../../theme/app_theme.dart';

class ListaActividadesScreen extends StatefulWidget {
  final int proyectoId;
  const ListaActividadesScreen({super.key, required this.proyectoId});

  @override
  State<ListaActividadesScreen> createState() => _ListaActividadesScreenState();
}

class _ListaActividadesScreenState extends State<ListaActividadesScreen> {
  final _repo = SgftpRepository.instance;
  String _estadoFiltro = 'Todas';
  DateTimeRange? _rango;
  List<Actividad> _actividades = [];
  bool _loading = true;
  String? _error;

  final _estados = ['Todas', 'En curso', 'Pendiente', 'Completada'];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() { _loading = true; _error = null; });
    try {
      final data = await _repo.getActividades(
        widget.proyectoId,
        estado: _estadoFiltro,
        desde: _rango?.start,
        hasta: _rango?.end,
      );
      setState(() { _actividades = data; _loading = false; });
    } catch (e) {
      setState(() { _error = 'Error al cargar actividades.'; _loading = false; });
    }
  }

  Future<void> _seleccionarRango() async {
    final r = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2027),
      initialDateRange: _rango,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(primary: kPrimary),
        ),
        child: child!,
      ),
    );
    if (r != null) {
      setState(() => _rango = r);
      _cargar();
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd/MM/yy');
    return Scaffold(
      appBar: AppBar(title: const Text('Actividades')),
      body: Column(
        children: [
          // Filter chips
          SizedBox(
            height: 52,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _estados.length,
              itemBuilder: (_, i) {
                final e = _estados[i];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(e),
                    selected: _estadoFiltro == e,
                    onSelected: (_) {
                      setState(() => _estadoFiltro = e);
                      _cargar();
                    },
                    selectedColor: kPrimary.withOpacity(0.15),
                    checkmarkColor: kPrimary,
                  ),
                );
              },
            ),
          ),
          // Date range picker
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _seleccionarRango,
                    icon: const Icon(Icons.date_range_outlined, size: 16),
                    label: Text(
                      _rango == null
                          ? 'Filtrar por fechas'
                          : '${fmt.format(_rango!.start)} – ${fmt.format(_rango!.end)}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                if (_rango != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      setState(() => _rango = null);
                      _cargar();
                    },
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _loading
                ? const LoadingCenter()
                : _error != null
                    ? ErrorCenter(_error!, onRetry: _cargar)
                    : _actividades.isEmpty
                        ? const Center(child: Text('Sin actividades'))
                        : RefreshIndicator(
                            onRefresh: _cargar,
                            child: ListView.builder(
                              itemCount: _actividades.length,
                              itemBuilder: (_, i) =>
                                  _ActividadCard(_actividades[i]),
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}

class _ActividadCard extends StatelessWidget {
  final Actividad a;
  const _ActividadCard(this.a);

  @override
  Widget build(BuildContext context) {
    final enCurso = a.estado == 'En curso';
    return Card(
      child: InkWell(
        onTap: () => context.push('/actividades/${a.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: enCurso
              ? BoxDecoration(
                  border: const Border(
                    left: BorderSide(color: Color(0xFF2E7D32), width: 4),
                  ),
                  borderRadius: BorderRadius.circular(12),
                )
              : null,
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            a.nombre,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        EstadoBadge(a.estado),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 13, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(a.fecha,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                        const SizedBox(width: 12),
                        const Icon(Icons.group_outlined,
                            size: 13, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('${a.voluntariosIds.length} voluntarios',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
