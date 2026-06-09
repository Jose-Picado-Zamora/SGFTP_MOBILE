import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/voluntario.dart';
import '../../data/repositories/sgftp_repository.dart';
import '../widgets/common_widgets.dart';

class ListaVoluntariosScreen extends StatefulWidget {
  const ListaVoluntariosScreen({super.key});

  @override
  State<ListaVoluntariosScreen> createState() =>
      _ListaVoluntariosScreenState();
}

class _ListaVoluntariosScreenState extends State<ListaVoluntariosScreen> {
  final _repo = SgftpRepository.instance;
  final _searchCtrl = TextEditingController();
  List<Voluntario> _voluntarios = [];
  bool _loading = true;
  String? _error;

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
      final data = await _repo.getVoluntarios(query: _searchCtrl.text);
      setState(() { _voluntarios = data; _loading = false; });
    } catch (e) {
      setState(() { _error = 'Error al cargar voluntarios.'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voluntarios')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SearchBar(
              controller: _searchCtrl,
              hintText: 'Buscar por nombre o cédula...',
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
          Expanded(
            child: _loading
                ? const LoadingCenter()
                : _error != null
                    ? ErrorCenter(_error!, onRetry: _cargar)
                    : _voluntarios.isEmpty
                        ? const Center(child: Text('Sin resultados'))
                        : RefreshIndicator(
                            onRefresh: _cargar,
                            child: ListView.builder(
                              itemCount: _voluntarios.length,
                              itemBuilder: (_, i) =>
                                  _VoluntarioTile(_voluntarios[i]),
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}

class _VoluntarioTile extends StatelessWidget {
  final Voluntario v;
  const _VoluntarioTile(this.v);

  @override
  Widget build(BuildContext context) {
    final activo = v.estado == 'Activo';
    return Card(
      child: InkWell(
        onTap: () => context.push('/voluntarios/${v.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              AvatarIniciales(v.iniciales),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(v.nombre,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 3),
                    Text(v.cedula,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: activo ? const Color(0xFF2E7D32) : Colors.orange,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                v.estado,
                style: TextStyle(
                    fontSize: 12,
                    color: activo ? const Color(0xFF2E7D32) : Colors.orange),
              ),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}