import 'package:dio/dio.dart';
import 'package:ecopraia/core/env.dart';

/// Cliente HTTP para comunicação com a API REST
/// Configurado com Dio e pronto para uso futuro
class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Interceptadores para logs e tratamento de erros
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (object) {
        // TODO: Configurar logger personalizado em produção
        print(object);
      },
    ));

    // Interceptador para tratamento de erros
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        // TODO: Implementar tratamento de erros personalizado
        // Ex: refresh token, logout automático, etc.
        handler.next(error);
      },
    ));
  }

  /// Realiza uma requisição GET
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }

  /// Realiza uma requisição POST
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }

  /// Realiza uma requisição PUT
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }

  /// Realiza uma requisição DELETE
  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return await _dio.delete(
      path,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }
}