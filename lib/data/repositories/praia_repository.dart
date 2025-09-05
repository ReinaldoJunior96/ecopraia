import 'package:ecopraia/data/models/praia.dart';

/// Interface abstrata para o repositório de praias
abstract class PraiaRepository {
  /// Busca praias dentro de uma bounding box (área do mapa)
  Future<List<Praia>> getPraiasByBbox({
    required double minLng,
    required double minLat,
    required double maxLng,
    required double maxLat,
  });

  /// Busca detalhes de uma praia específica
  Future<Praia?> getPraiaDetail(int id);

  /// Busca todas as praias disponíveis
  Future<List<Praia>> getAllPraias();
}