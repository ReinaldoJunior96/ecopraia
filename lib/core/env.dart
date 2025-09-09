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

  // Chave da API do Supabase
  static const supabaseApiKey = String.fromEnvironment(
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndmaXN0ZGFnaG9zeWxzeGRwcXl1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc0MzcwOTEsImV4cCI6MjA3MzAxMzA5MX0.QTd7x8gY8uy6TwJcHTPJJOKlSI7O4ASoalmOgcH8Kd8',
    defaultValue: '',
  );
}
