import 'package:ecopraia/data/models/praia.dart';
import 'package:ecopraia/data/models/poi.dart';

/// Dados estáticos para simulação da API
class LocalMockData {
  /// Lista de praias de São Luís - MA
  static final List<Praia> praias = [
    Praia(
      id: 1,
      nome: 'Bombeiros Marítimos (2 Cia)',
      lat: -2.488492,
      lng: -44.284579,
      status: 'cinza',
      bairro: 'Calhau',
      descricao: '',
      categoria: 'bombeiro',
      pois: [],
    ),
    Praia(
      id: 2,
      nome: 'Ponta d’Areia',
      lat: -2.496816,
      lng: -44.307940,
      status: 'cinza',
      bairro: 'Ponta d’Areia',
      descricao: '',
      categoria: 'praia',
      pois: [],
    ),
    Praia(
      id: 3,
      nome: 'Olho d’Água',
      lat: -2.4793773,
      lng: -44.2264065,
      status: 'cinza',
      bairro: 'Olho d’Água',
      descricao: '',
      categoria: 'praia',
      pois: [],
    ),
    Praia(
      id: 4,
      nome: 'Praia do Calhau',
      lat: -2.4827168,
      lng: -44.2582379,
      status: 'cinza',
      bairro: 'Calhau',
      descricao: '',
      categoria: 'praia',
      pois: [],
    ),
    Praia(
      id: 5,
      nome: 'Praia do Amor',
      lat: -2.5350348,
      lng: -44.3500276,
      status: 'cinza',
      bairro: 'Araçagy',
      descricao: '',
      categoria: 'praia',
      pois: [],
    ),
  ];

  /// Simula busca por praias dentro de uma bounding box
  static Future<List<Praia>> getPraiasByBbox({
    required double minLng,
    required double minLat,
    required double maxLng,
    required double maxLat,
  }) async {
    // Simula delay da API
    await Future.delayed(const Duration(milliseconds: 500));

    return praias.where((praia) {
      return praia.lat >= minLat &&
          praia.lat <= maxLat &&
          praia.lng >= minLng &&
          praia.lng <= maxLng;
    }).toList();
  }

  /// Simula busca de detalhes de uma praia específica
  static Future<Praia?> getPraiaDetail(int id) async {
    // Simula delay da API
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      return praias.firstWhere((praia) => praia.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Retorna todas as praias (para a tela de descoberta)
  static Future<List<Praia>> getAllPraias() async {
    // Simula delay da API
    await Future.delayed(const Duration(milliseconds: 400));

    return List.from(praias);
  }

  /// Simula erro na API (para testes)
  static Future<List<Praia>> getPraiasWithError() async {
    await Future.delayed(const Duration(milliseconds: 800));
    throw Exception('Erro ao carregar praias. Verifique sua conexão.');
  }
}
