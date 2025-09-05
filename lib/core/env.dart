/// Configurações de ambiente da aplicação
class Env {
  // Base URL da API (será usado futuramente)
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3333/api',
  );

  // Chaves do Google Maps
  static const mapsAndroidKey = String.fromEnvironment(
    'MAPS_ANDROID_API_KEY',
    defaultValue: '',
  );
  
  static const mapsIosKey = String.fromEnvironment(
    'MAPS_IOS_API_KEY',
    defaultValue: '',
  );
}