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
      descricao: 'Posto de bombeiros marítimos localizado no Calhau.',
      categoria: 'bombeiro',
      pois: [
        Poi(
          id: 1,
          tipo: 'banheiro_publico',
          lat: -2.488400,
          lng: -44.284500,
          descricao: 'Banheiro próximo ao posto de bombeiros.',
        ),
      ],
      mediaNotas: 4.0,
      totalAvaliacoes: 15,
      acessibilidade: true,
      tags: ['segurança', 'serviço'],
      imagemCapa: 'https://exemplo.com/imagens/bombeiros-calhau.jpg',
      atualizadoEm: DateTime.now(),
    ),
    Praia(
      id: 2,
      nome: 'Ponta d’Areia',
      lat: -2.496816,
      lng: -44.307940,
      status: 'cinza',
      bairro: 'Ponta d’Areia',
      descricao: 'Praia urbana famosa pelo Espigão, boa para caminhada.',
      categoria: 'praia',
      pois: [
        Poi(
          id: 1,
          tipo: 'banheiro_publico',
          lat: -2.496500,
          lng: -44.307500,
          descricao: 'Banheiro no Espigão.',
        ),
        Poi(
          id: 2,
          tipo: 'ducha',
          lat: -2.496900,
          lng: -44.308100,
          descricao: 'Ducha próxima ao Espigão.',
        ),
      ],
      mediaNotas: 4.2,
      totalAvaliacoes: 23,
      acessibilidade: true,
      tags: ['urbana', 'passeio', 'família'],
      imagemCapa: 'https://exemplo.com/imagens/ponta-dareia.jpg',
      atualizadoEm: DateTime.now(),
    ),
    Praia(
      id: 3,
      nome: 'Olho d’Água',
      lat: -2.4793773,
      lng: -44.2264065,
      status: 'cinza',
      bairro: 'Olho d’Água',
      descricao: 'Praia tranquila, ideal para famílias e esportes aquáticos.',
      categoria: 'praia',
      pois: [
        Poi(
          id: 1,
          tipo: 'quiosque',
          lat: -2.479300,
          lng: -44.226300,
          descricao: 'Quiosque com opções de comida e bebida.',
        ),
      ],
      mediaNotas: 4.5,
      totalAvaliacoes: 30,
      acessibilidade: true,
      tags: ['família', 'esportes'],
      imagemCapa: 'https://exemplo.com/imagens/olho-dagua.jpg',
      atualizadoEm: DateTime.now(),
    ),
    Praia(
      id: 4,
      nome: 'Praia do Calhau',
      lat: -2.4827168,
      lng: -44.2582379,
      status: 'cinza',
      bairro: 'Calhau',
      descricao: 'Praia movimentada com boa estrutura e opções de lazer.',
      categoria: 'praia',
      pois: [
        Poi(
          id: 1,
          tipo: 'ducha',
          lat: -2.482700,
          lng: -44.258200,
          descricao: 'Ducha próxima ao estacionamento.',
        ),
        Poi(
          id: 2,
          tipo: 'banheiro_publico',
          lat: -2.482600,
          lng: -44.258100,
          descricao: 'Banheiro próximo ao quiosque.',
        ),
      ],
      mediaNotas: 4.8,
      totalAvaliacoes: 50,
      acessibilidade: true,
      tags: ['estrutura', 'lazer'],
      imagemCapa: 'https://exemplo.com/imagens/calhau.jpg',
      atualizadoEm: DateTime.now(),
    ),
    Praia(
      id: 5,
      nome: 'Praia do Amor',
      lat: -2.5350348,
      lng: -44.3500276,
      status: 'cinza',
      bairro: 'Araçagy',
      descricao: 'Praia romântica e tranquila, ideal para casais.',
      categoria: 'praia',
      pois: [
        Poi(
          id: 1,
          tipo: 'quiosque',
          lat: -2.535000,
          lng: -44.350000,
          descricao: 'Quiosque com opções de comida e bebida.',
        ),
      ],
      mediaNotas: 4.6,
      totalAvaliacoes: 40,
      acessibilidade: true,
      tags: ['romântica', 'tranquila'],
      imagemCapa: 'https://exemplo.com/imagens/praia-do-amor.jpg',
      atualizadoEm: DateTime.now(),
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
