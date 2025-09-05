import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecopraia/data/models/praia.dart';
import 'package:ecopraia/data/repositories/praia_repository.dart';
import 'package:ecopraia/presentation/map/widgets/status_badge.dart';
import 'package:ecopraia/core/utils.dart';

/// Estado para a tela de descoberta
class DiscoverState extends ChangeNotifier {
  final PraiaRepository _repository;

  DiscoverState({required PraiaRepository repository}) : _repository = repository;

  List<Praia> _praias = [];
  List<Praia> get praias => _praias;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Carrega todas as praias
  Future<void> loadPraias() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _praias = await _repository.getAllPraias();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Tenta recarregar as praias
  Future<void> retry() async {
    await loadPraias();
  }
}

/// Tela de descoberta com lista de praias
class DiscoverScreen extends StatefulWidget {
  final Function(Praia)? onPraiaSelected;

  const DiscoverScreen({
    Key? key,
    this.onPraiaSelected,
  }) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late DiscoverState _discoverState;

  @override
  void initState() {
    super.initState();
    _discoverState = DiscoverState(
      repository: context.read<PraiaRepository>(),
    );
    _discoverState.loadPraias();
  }

  @override
  void dispose() {
    _discoverState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descobrir Praias'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 1,
      ),
      body: ChangeNotifierProvider.value(
        value: _discoverState,
        child: Consumer<DiscoverState>(
          builder: (context, state, child) {
            if (state.isLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Carregando praias...'),
                  ],
                ),
              );
            }

            if (state.errorMessage != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Ops! Algo deu errado',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.errorMessage!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: state.retry,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state.praias.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.beach_access,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Nenhuma praia encontrada',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: state.loadPraias,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.praias.length,
                itemBuilder: (context, index) {
                  final praia = state.praias[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PraiaCard(
                      praia: praia,
                      onTap: () {
                        widget.onPraiaSelected?.call(praia);
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Card que representa uma praia na lista de descoberta
class PraiaCard extends StatelessWidget {
  final Praia praia;
  final VoidCallback? onTap;

  const PraiaCard({
    Key? key,
    required this.praia,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com nome e status
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          praia.nome,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (praia.bairro != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            praia.bairro!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  StatusBadge(
                    status: praia.status,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                ],
              ),

              // Descrição (se houver)
              if (praia.descricao != null) ...[
                const SizedBox(height: 8),
                Text(
                  praia.descricao!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              // Coordenadas e POIs
              const SizedBox(height: 12),
              Row(
                children: [
                  // Coordenadas
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    AppUtils.formatCoordinates(praia.lat, praia.lng),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Número de POIs
                  if (praia.pois.isNotEmpty) ...[
                    Icon(
                      Icons.place,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${praia.pois.length} POI${praia.pois.length > 1 ? 's' : ''}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),

              // Botão "Ver no mapa"
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.map, size: 16),
                  label: const Text('Ver no mapa'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}