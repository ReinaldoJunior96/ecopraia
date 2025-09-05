# Praia+Segura 🏖️

Aplicativo Flutter para mapa interativo de praias com informações de segurança em São Luís - MA.

## 🚀 Funcionalidades Implementadas

### MVP Básico
- ✅ **Mapa em tela cheia** com Google Maps Flutter
- ✅ **Localização inicial** em São Luís - MA (-2.53, -44.28)
- ✅ **Marcadores coloridos** por status das praias:
  - 🟢 Verde (segura)
  - 🟡 Amarelo (atenção) 
  - 🔴 Vermelho (risco)
  - ⚪ Cinza (sem dados)
- ✅ **Bottom sheet interativo** com detalhes da praia
- ✅ **Filtros de POIs** no topo do mapa
- ✅ **Carregamento por área** (bbox) com debounce
- ✅ **Tela de descoberta** com lista de praias
- ✅ **Navegação por abas** (Mapa + Descobrir)
- ✅ **Botão "Como chegar"** (abre Google Maps externo)
- ✅ **Localização do usuário** com botão "Minha localização"

### Arquitetura
- ✅ **State Management** com Provider
- ✅ **Repository Pattern** com MockPraiaRepository
- ✅ **Camadas organizadas** (core, data, services, presentation)
- ✅ **Dados mock** com 6 praias de São Luís
- ✅ **Interface preparada** para API futura

## 📋 Pré-requisitos

1. **Flutter SDK** (versão 3.6.0 ou superior)
2. **Chave do Google Maps** (obrigatória para funcionamento completo)

## 🔑 Configuração do Google Maps

### 1. Obtenha uma chave da API do Google Maps

1. Acesse o [Google Cloud Console](https://console.cloud.google.com/)
2. Crie um novo projeto ou selecione um existente
3. Ative as seguintes APIs:
   - Maps SDK for Android
   - Maps SDK for iOS
4. Crie uma chave de API em "Credenciais"

### 2. Configure a chave no Android

Edite o arquivo `android/app/src/main/AndroidManifest.xml`:

```xml
<!-- Descomente e adicione sua chave: -->
<meta-data 
    android:name="com.google.android.geo.API_KEY"
    android:value="SUA_CHAVE_DO_GOOGLE_MAPS_AQUI"/>
```

### 3. Configure a chave no iOS

1. Edite `ios/Runner/AppDelegate.swift`:
```swift
// Descomente as linhas:
import GoogleMaps
// E no didFinishLaunchingWithOptions:
GMSServices.provideAPIKey("SUA_CHAVE_DO_GOOGLE_MAPS_AQUI")
```

## 🏃‍♂️ Como Executar

### Método 1: Execução Simples
```bash
flutter pub get
flutter run
```

### Método 2: Com Variáveis de Ambiente (Recomendado)
```bash
flutter run \
  --dart-define=API_BASE_URL=https://minhaapi.com/api \
  --dart-define=MAPS_ANDROID_API_KEY=SUA_CHAVE_ANDROID \
  --dart-define=MAPS_IOS_API_KEY=SUA_CHAVE_IOS
```

## 🏖️ Praias Implementadas (Mock)

1. **Praia do Calhau** - Segura (Calhau)
2. **Praia da Ponta da Areia** - Atenção (Ponta da Areia) 
3. **Praia do Olho D'Água** - Segura (Olho D'Água)
4. **Praia de São Marcos** - Risco (São Marcos)
5. **Praia do Araçagi** - Sem dados (Araçagi)
6. **Praia do Meio** - Atenção (Centro)

Cada praia possui POIs (banheiro, ducha, lixeira, posto salva-vidas, quiosque, estacionamento).

## 🔄 Migração para API Real

### 1. Trocar o Repository

No arquivo `lib/app.dart`, substitua:

```dart
// De:
_repository = MockPraiaRepository();

// Para:
_repository = ApiPraiaRepository(
  apiClient: ApiClient(),
);
```

### 2. Implementar ApiPraiaRepository

Complete a implementação em `lib/data/repositories/api_praia_repository.dart`:

- `GET /praias?bbox=minLng,minLat,maxLng,maxLat` - Busca por área
- `GET /praias/{id}` - Detalhes da praia  
- `GET /praias` - Todas as praias

### 3. Formato Esperado da API

```json
{
  "data": [
    {
      "id": 1,
      "nome": "Praia do Calhau",
      "lat": -2.4965,
      "lng": -44.2410,
      "status": "segura",
      "bairro": "Calhau",
      "descricao": "Uma das praias mais populares...",
      "pois": [
        {
          "id": 1,
          "tipo": "banheiro",
          "lat": -2.4965,
          "lng": -44.2408
        }
      ]
    }
  ]
}
```

## 📱 Permissões

### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### iOS (`ios/Runner/Info.plist`)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Este app precisa acessar sua localização para mostrar praias próximas e sua posição no mapa.</string>
```

## 🐛 Troubleshooting

### Erro "Google Maps not working"
- Verifique se adicionou a chave correta nos arquivos de configuração
- Confirme se as APIs estão ativadas no Google Cloud Console
- Verifique se há cotas/limites atingidos na API

### Erro de permissão de localização
- Aceite as permissões quando solicitadas
- Verifique se as permissões estão configuradas corretamente no AndroidManifest.xml e Info.plist

### Performance lenta com muitos marcadores
- Implemente clustering de marcadores (flutter_map_marker_cluster)
- Considere carregar apenas praias visíveis na tela

---

**Desenvolvido com ❤️ para a segurança das praias do Maranhão** 🌊
