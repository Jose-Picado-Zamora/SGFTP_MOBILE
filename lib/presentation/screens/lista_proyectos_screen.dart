import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/proyecto.dart';
import '../../data/repositories/sgftp_repository.dart';
import '../widgets/common_widgets.dart';
import '../../theme/app_theme.dart';

class ListaProyectosScreen extends StatefulWidget {
  const ListaProyectosScreen({super.key});
  @override
  State<ListaProyectosScreen> createState() => _ListaProyectosScreenState();
}

class _ListaProyectosScreenState extends State<ListaProyectosScreen> {
  final _repo = SgftpRepository.instance;
  final _searchCtrl = TextEditingController();
  String _estadoFiltro = 'Todos';
  List<Proyecto> _proyectos = [];
  bool _loading = true;
  String? _error;

  final _estados = ['Todos', 'Activo', 'Inactivo', 'Completado'];

  @override
  void initState() {
    super.initState();
    _cargar();
    _searchCtrl.addListener(_cargar);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    setState(() { _loading = true; _error = null; });
    try {
      final data = await _repo.getProyectos(
        estado: _estadoFiltro,
        nombre: _searchCtrl.text,
      );
      setState(() { _proyectos = data; _loading = false; });
    } catch (e) {
      setState(() { _error = 'Error al cargar proyectos.\n$e'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proyectos')),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: SearchBar(
              controller: _searchCtrl,
              hintText: 'Buscar proyecto por nombre...',
              leading: const Icon(Icons.search),
              trailing: _searchCtrl.text.isNotEmpty
                  ? [
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          _cargar();
                        },
                      )
                    ]
                  : null,
              padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 16)),
            ),
          ),
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
          // Lista
          Expanded(
            child: _loading
                ? const LoadingCenter()
                : _error != null
                    ? ErrorCenter(_error!, onRetry: _cargar)
                    : _proyectos.isEmpty
                        ? const Center(child: Text('Sin resultados'))
                        : RefreshIndicator(
                            onRefresh: _cargar,
                            child: ListView.builder(
                              itemCount: _proyectos.length,
                              itemBuilder: (_, i) =>
                                  _ProyectoCard(_proyectos[i]),
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}

class _ProyectoCard extends StatelessWidget {
  final Proyecto p;
  const _ProyectoCard(this.p);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => context.push('/proyectos/${p.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      p.nombre,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  EstadoBadge(p.estado),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(p.fechaInicio,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 12),
              BarraProgreso(p.progreso),
            ],
          ),
        ),
      ),
    );
  }
}
