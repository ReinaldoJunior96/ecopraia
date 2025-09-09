import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:ecopraia/data/models/praia.dart';
import 'package:ecopraia/presentation/map/map_state.dart';
import 'package:ecopraia/presentation/map/widgets/poi_chip_list.dart';
import 'package:ecopraia/presentation/map/widgets/loading_chip.dart';
import 'package:ecopraia/presentation/map/widgets/praia_bottom_sheet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ecopraia/presentation/widgets/app_sidemenu.dart';
import 'package:ecopraia/presentation/map/praia_details_screen.dart';

/// Tela principal do mapa com praias interativas
class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  void _logout() async {
    // Apenas para fechar o Drawer, sem ação de logout real
    Navigator.of(context).pop();
  }

  String _categoriaSelecionada = 'todas';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapState>().loadInitialBeaches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppSideMenu(onLogout: _logout),
      body: Consumer<MapState>(
        builder: (context, mapState, child) {
          return Stack(
            children: [
              // OpenStreetMap (flutter_map)
              FlutterMap(
                options: MapOptions(
                  center: LatLng(MapState.initialCenter.latitude,
                      MapState.initialCenter.longitude),
                  zoom: MapState.initialZoom,
                ),
                children: [
                  // CartoDB Voyager: mapa colorido e agradável para cidades de praia
                  TileLayer(
                    urlTemplate:
                        'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                    subdomains: ['a', 'b', 'c', 'd'],
                    userAgentPackageName: 'com.ecopraia.app',
                  ),
                  MarkerLayer(
                    markers: _buildFlutterMapMarkers(mapState),
                  ),
                ],
              ),

              // Filtros de POI no topo + botão registrar praia
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      // Botão flutuante de menu
                      Material(
                        color: Colors.white,
                        elevation: 4,
                        shape: const CircleBorder(),
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu,
                                color: Colors.teal, size: 28),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Todas'),
                        selected: _categoriaSelecionada == 'todas',
                        onSelected: (v) =>
                            setState(() => _categoriaSelecionada = 'todas'),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Praias'),
                        selected: _categoriaSelecionada == 'praia',
                        onSelected: (v) =>
                            setState(() => _categoriaSelecionada = 'praia'),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Bombeiros'),
                        selected: _categoriaSelecionada == 'bombeiro',
                        onSelected: (v) =>
                            setState(() => _categoriaSelecionada = 'bombeiro'),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),

              // Chip de carregamento
              Positioned(
                top: MediaQuery.of(context).padding.top + 80,
                left: 16,
                right: 16,
                child: Center(
                  child: LoadingChip(
                    isVisible: mapState.loadingState == MapLoadingState.loading,
                  ),
                ),
              ),

              // Chip de erro
              Positioned(
                top: MediaQuery.of(context).padding.top + 80,
                left: 16,
                right: 16,
                child: Center(
                  child: ErrorChip(
                    message: mapState.errorMessage ?? 'Erro desconhecido',
                    onRetry: mapState.retry,
                    isVisible: mapState.loadingState == MapLoadingState.error,
                  ),
                ),
              ),

              // Botão flutuante para registrar praia
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  backgroundColor: Colors.teal,
                  onPressed: () {
                    mapState.getCurrentLocation().then((_) {
                      final pos = mapState.currentPosition;
                      if (pos != null) {
                        mapState.registerMockPraiaComLoc(
                            pos.latitude, pos.longitude);
                        print(
                            'Praia registrada em: lat ${pos.latitude}, lng ${pos.longitude}');
                      } else {
                        print('Localização não disponível');
                      }
                    });
                  },
                  child: const Icon(Icons.add_location, color: Colors.white),
                ),
              ),

              // Bottom sheet da praia selecionada
              if (mapState.selectedPraia != null)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: mapState.clearSelection,
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () {}, // Evita fechar ao tocar no sheet
                          child: PraiaBottomSheet(
                            praia: mapState.selectedPraia!,
                            onClose: mapState.clearSelection,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  /// Constrói os marcadores do mapa baseado nas praias carregadas
  List<Marker> _buildFlutterMapMarkers(MapState mapState) {
    // Filtra pelas categorias
    final praiasFiltradas = _categoriaSelecionada == 'todas'
        ? mapState.praias
        : mapState.praias
            .where((p) => p.categoria == _categoriaSelecionada)
            .toList();
    return praiasFiltradas
        .map((praia) {
          final isSelected = mapState.selectedPraia == praia;
          final isBombeiro = praia.nome.toLowerCase().contains('bombeiro') ||
              praia.nome.toLowerCase().contains('militar');
          final icon = isBombeiro
              ? FaIcon(FontAwesomeIcons.fireExtinguisher,
                  color: Colors.white, size: isSelected ? 28 : 15)
              : FaIcon(FontAwesomeIcons.umbrellaBeach,
                  color: Colors.white, size: isSelected ? 28 : 15);
          final markerColor = isBombeiro
              ? Colors.orange
              : (isSelected ? Colors.blue : Colors.teal);
          final marker = Container(
            decoration: BoxDecoration(
              color: markerColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(child: icon),
          );
          return Marker(
            point: LatLng(praia.lat, praia.lng),
            width: isSelected ? 60 : 40,
            height: isSelected ? 60 : 40,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PraiaDetailsScreen(praia: praia),
                ),
              ),
              child: marker,
            ),
          );
        })
        .toList()
        .cast<Marker>();
  }

  Widget _buildRatingRow(String label, double rating) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(width: 8),
        Row(
          children: List.generate(5, (index) {
            if (index < rating.floor()) {
              return const Icon(Icons.star, color: Colors.yellow, size: 20);
            } else if (index < rating) {
              return const Icon(Icons.star_half,
                  color: Colors.yellow, size: 20);
            } else {
              return const Icon(Icons.star_border,
                  color: Colors.yellow, size: 20);
            }
          }),
        ),
      ],
    );
  }
}
