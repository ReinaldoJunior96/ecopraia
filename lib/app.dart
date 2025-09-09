import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecopraia/data/models/praia.dart';
import 'package:ecopraia/data/repositories/praia_repository.dart';
import 'package:ecopraia/services/api_client.dart';
import 'package:ecopraia/data/repositories/api_praia_repository.dart';
import 'package:ecopraia/presentation/map/map_screen.dart';
import 'package:ecopraia/presentation/map/map_state.dart';
import 'package:ecopraia/presentation/discover/discover_screen.dart';

/// App principal com navegação por abas
class PraiaMaisSeguraApp extends StatefulWidget {
  const PraiaMaisSeguraApp({Key? key}) : super(key: key);

  @override
  State<PraiaMaisSeguraApp> createState() => _PraiaMaisSeguraAppState();
}

class _PraiaMaisSeguraAppState extends State<PraiaMaisSeguraApp> {
  int _currentIndex = 0;
  late final PraiaRepository _repository;
  late final MapState _mapState;

  @override
  void initState() {
    super.initState();
    // TODO: Futuramente, trocar por ApiPraiaRepository quando API estiver pronta
    _repository = ApiPraiaRepository(apiClient: ApiClient());
    _mapState = MapState(repository: _repository);
  }

  @override
  void dispose() {
    _mapState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PraiaRepository>.value(value: _repository),
        ChangeNotifierProvider<MapState>.value(value: _mapState),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            // Tela do Mapa
            const MapScreen(),

            // Tela de Descoberta
            DiscoverScreen(
              onPraiaSelected: (praia) => _onPraiaSelected(praia),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                activeIcon: Icon(Icons.map),
                label: 'Mapa',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                activeIcon: Icon(Icons.explore),
                label: 'Descobrir',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Callback chamado quando uma praia é selecionada na tela de descoberta
  void _onPraiaSelected(Praia praia) {
    // Muda para a aba do mapa
    setState(() {
      _currentIndex = 0;
    });

    // Move o mapa para a praia selecionada
    Future.delayed(const Duration(milliseconds: 300), () {
      // Removido: método moveToBeach não existe mais
    });
  }
}
