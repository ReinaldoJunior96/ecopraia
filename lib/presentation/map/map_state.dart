import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ecopraia/data/models/praia.dart';
import 'package:ecopraia/data/repositories/praia_repository.dart';
import 'package:ecopraia/services/map_service.dart';

/// Estados possíveis do mapa
enum MapLoadingState {
  initial,
  loading,
  loaded,
  error,
}

/// Provider de estado para a tela do mapa
class MapState extends ChangeNotifier {
  /// Adiciona uma praia mockada usando lat/lng informados
  void registerMockPraiaComLoc(double lat, double lng) {
    final novaPraia = Praia(
      id: _praias.length + 100,
      nome: 'Praia Registrada',
      lat: lat,
      lng: lng,
      categoria: 'praia',
      status: 'registrada',
      bairro: 'Novo Bairro',
      descricao: 'Praia registrada pelo usuário.',
      pois: [],
      mediaNotas: 0.0,
      totalAvaliacoes: 0,
      acessibilidade: false,
      tags: [],
      imagemCapa: '',
      atualizadoEm: DateTime.now(),
    );
    _praias.add(novaPraia);
    notifyListeners();
  }

  /// Adiciona uma praia mockada com localização fixa
  void registerMockPraia() {
    // Localização fixa para teste
    final novaPraia = Praia(
      id: _praias.length + 100,
      nome: 'Praia Registrada',
      lat: -2.4800,
      lng: -44.2316,
      status: 'registrada',
      bairro: 'Novo Bairro',
      categoria: 'praia',
      descricao: 'Praia registrada pelo usuário.',
      pois: [],
      mediaNotas: 0.0,
      totalAvaliacoes: 0,
      acessibilidade: false,
      tags: [],
      imagemCapa: '',
      atualizadoEm: DateTime.now(),
    );
    _praias.add(novaPraia);
    notifyListeners();
  }

  final PraiaRepository _repository;

  MapState({required PraiaRepository repository}) : _repository = repository;

  // Estado de carregamento
  MapLoadingState _loadingState = MapLoadingState.initial;
  MapLoadingState get loadingState => _loadingState;

  // Erro atual
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Removido: controlador do Google Maps

  // Lista de praias carregadas
  List<Praia> _praias = [];
  List<Praia> get praias => _praias;

  // Praia selecionada
  Praia? _selectedPraia;
  Praia? get selectedPraia => _selectedPraia;

  // Filtros de POIs
  final Set<String> _selectedPoiFilters = {};
  Set<String> get selectedPoiFilters => Set.unmodifiable(_selectedPoiFilters);

  // Posição atual do usuário
  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  // Timer para debounce
  Timer? _debounceTimer;

  // Configurações iniciais do mapa (OpenStreetMap)
  static const initialCenterLat = -2.53;
  static const initialCenterLng = -44.28;
  static const double initialZoom = 12.0;
  static LatLng get initialCenter => LatLng(initialCenterLat, initialCenterLng);

  /// Carrega praias iniciais
  Future<void> loadInitialBeaches() async {
    if (_loadingState != MapLoadingState.initial) return;

    _setLoadingState(MapLoadingState.loading);

    try {
      final bbox = MapService.calculateBoundingBox(
          MapState.initialCenter, MapState.initialZoom);
      final praias = await _repository.getPraiasByBbox(
        minLat: bbox['minLat']!,
        maxLat: bbox['maxLat']!,
        minLng: bbox['minLng']!,
        maxLng: bbox['maxLng']!,
      );

      _praias = praias;
      //print('Praias carregadas: ${praias.map((p) => p.toJson()).toList()}');
      _setLoadingState(MapLoadingState.loaded);
    } catch (e) {
      _setError('Erro ao carregar praias: ${e.toString()}');
    }
  }

  /// Seleciona uma praia
  void selectBeach(Praia praia) {
    _selectedPraia = praia;
    notifyListeners();
  }

  /// Limpa a seleção de praia
  void clearSelection() {
    _selectedPraia = null;
    notifyListeners();
  }

  // Removido: método de movimentação do Google Maps

  /// Adiciona ou remove um filtro de POI
  void togglePoiFilter(String poiType) {
    if (_selectedPoiFilters.contains(poiType)) {
      _selectedPoiFilters.remove(poiType);
    } else {
      _selectedPoiFilters.add(poiType);
    }
    notifyListeners();
  }

  /// Limpa todos os filtros de POI
  void clearPoiFilters() {
    _selectedPoiFilters.clear();
    notifyListeners();
  }

  /// Obtém a localização atual do usuário
  Future<void> getCurrentLocation() async {
    try {
      final position = await MapService.getCurrentLocation();
      if (position != null) {
        _currentPosition = position;

        // Removido: movimentação do Google Maps

        notifyListeners();
      }
    } catch (e) {
      _setError('Erro ao obter localização: ${e.toString()}');
    }
  }

  /// Tenta recarregar as praias
  Future<void> retry() async {
    _clearError();

    await loadInitialBeaches();
  }

  /// Define o estado de carregamento
  void _setLoadingState(MapLoadingState state) {
    _loadingState = state;
    notifyListeners();
  }

  /// Define uma mensagem de erro
  void _setError(String message) {
    _errorMessage = message;
    _loadingState = MapLoadingState.error;
    notifyListeners();
  }

  /// Limpa o erro atual
  void _clearError() {
    _errorMessage = null;
    if (_loadingState == MapLoadingState.error) {
      _loadingState = MapLoadingState.initial;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
