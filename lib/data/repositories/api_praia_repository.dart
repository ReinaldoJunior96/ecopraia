import 'package:ecopraia/data/models/praia.dart';
import 'package:ecopraia/data/repositories/praia_repository.dart';
import 'package:ecopraia/services/api_client.dart';

/// Implementação do repositório de praias usando API REST
/// TODO: Implementar quando a API estiver disponível
class ApiPraiaRepository implements PraiaRepository {
  final ApiClient _apiClient;

  ApiPraiaRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<List<Praia>> getPraiasByBbox({
    required double minLng,
    required double minLat,
    required double maxLng,
    required double maxLat,
  }) async {
    // TODO: Implementar chamada GET /praias?bbox=minLng,minLat,maxLng,maxLat
    try {
      final response = await _apiClient.get(
        '/praias',
        queryParameters: {
          'minLng': minLng.toString(),
          'minLat': minLat.toString(),
          'maxLng': maxLng.toString(),
          'maxLat': maxLat.toString(),
        },
      );

      final List<dynamic> data = response.data;
      return data.map((json) => Praia.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar praias: ${e.toString()}');
    }

    // Exemplo de implementação futura:
    /*
    try {
      final response = await _apiClient.get(
        '/praias',
        queryParameters: {
          'bbox': '$minLng,$minLat,$maxLng,$maxLat',
        },
      );
      
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Praia.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar praias: ${e.toString()}');
    }
    */
  }

  @override
  Future<Praia?> getPraiaDetail(int id) async {
    // TODO: Implementar chamada GET /praias/{id}
    throw UnimplementedError('API não implementada ainda');

    // Exemplo de implementação futura:
    /*
    try {
      final response = await _apiClient.get('/praias/$id');
      return Praia.fromJson(response.data['data']);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        return null;
      }
      throw Exception('Erro ao buscar detalhes da praia: ${e.toString()}');
    }
    */
  }

  @override
  Future<List<Praia>> getAllPraias() async {
    // TODO: Implementar chamada GET /praias
    throw UnimplementedError('API não implementada ainda');

    // Exemplo de implementação futura:
    /*
    try {
      final response = await _apiClient.get('/praias');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Praia.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar todas as praias: ${e.toString()}');
    }
    */
  }
}
