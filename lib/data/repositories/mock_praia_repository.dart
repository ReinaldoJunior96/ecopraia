import 'package:ecopraia/data/models/praia.dart';
import 'package:ecopraia/data/repositories/praia_repository.dart';
import 'package:ecopraia/data/mock/local_mock_data.dart';

/// Implementação mock do repositório de praias
/// Usa dados estáticos locais para simular uma API
class MockPraiaRepository implements PraiaRepository {
  @override
  Future<List<Praia>> getPraiasByBbox({
    required double minLng,
    required double minLat,
    required double maxLng,
    required double maxLat,
  }) async {
    // Ignora bounding box e retorna todas as praias mockadas
    try {
      return await LocalMockData.getAllPraias();
    } catch (e) {
      throw Exception('Erro ao buscar praias: ${e.toString()}');
    }
  }

  @override
  Future<Praia?> getPraiaDetail(int id) async {
    try {
      return await LocalMockData.getPraiaDetail(id);
    } catch (e) {
      throw Exception('Erro ao buscar detalhes da praia: ${e.toString()}');
    }
  }

  @override
  Future<List<Praia>> getAllPraias() async {
    try {
      return await LocalMockData.getAllPraias();
    } catch (e) {
      throw Exception('Erro ao buscar todas as praias: ${e.toString()}');
    }
  }
}
