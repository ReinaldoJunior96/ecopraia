import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ecopraia/theme.dart';

/// Utilitários para o status das praias
class BeachStatusUtils {
  /// Retorna a cor correspondente ao status da praia
  static Color getStatusColor(String status, {bool isDark = false}) {
    switch (status.toLowerCase()) {
      case 'segura':
      case 'verde':
        return isDark ? DarkModeColors.beachSafe : LightModeColors.beachSafe;
      case 'atenção':
      case 'atencao':
      case 'amarelo':
        return isDark ? DarkModeColors.beachWarning : LightModeColors.beachWarning;
      case 'risco':
      case 'vermelho':
        return isDark ? DarkModeColors.beachDanger : LightModeColors.beachDanger;
      case 'sem dados':
      case 'cinza':
      default:
        return isDark ? DarkModeColors.beachNoData : LightModeColors.beachNoData;
    }
  }

  /// Retorna o texto do status da praia em maiúsculas
  static String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'segura':
      case 'verde':
        return 'SEGURA';
      case 'atenção':
      case 'atencao':
      case 'amarelo':
        return 'ATENÇÃO';
      case 'risco':
      case 'vermelho':
        return 'RISCO';
      case 'sem dados':
      case 'cinza':
      default:
        return 'SEM DADOS';
    }
  }

  /// Retorna o emoji correspondente ao status
  static String getStatusEmoji(String status) {
    switch (status.toLowerCase()) {
      case 'segura':
      case 'verde':
        return '🟢';
      case 'atenção':
      case 'atencao':
      case 'amarelo':
        return '🟡';
      case 'risco':
      case 'vermelho':
        return '🔴';
      case 'sem dados':
      case 'cinza':
      default:
        return '⚪';
    }
  }
}

/// Utilitários para POIs
class PoiUtils {
  /// Retorna o ícone correspondente ao tipo de POI
  static IconData getPoiIcon(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'banheiro':
        return Icons.wc;
      case 'ducha':
        return Icons.shower;
      case 'lixeira':
        return Icons.delete_outline;
      case 'posto':
      case 'salva-vidas':
        return Icons.local_hospital;
      case 'quiosque':
        return Icons.store;
      case 'estacionamento':
        return Icons.local_parking;
      default:
        return Icons.place;
    }
  }

  /// Retorna a cor do ícone do POI
  static Color getPoiIconColor(String tipo, BuildContext context) {
    switch (tipo.toLowerCase()) {
      case 'banheiro':
        return Colors.blue;
      case 'ducha':
        return Colors.lightBlue;
      case 'lixeira':
        return Colors.green;
      case 'posto':
      case 'salva-vidas':
        return Colors.red;
      case 'quiosque':
        return Colors.orange;
      case 'estacionamento':
        return Colors.grey;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  /// Retorna o texto formatado do tipo de POI
  static String getPoiDisplayName(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'banheiro':
        return 'Banheiro';
      case 'ducha':
        return 'Ducha';
      case 'lixeira':
        return 'Lixeira';
      case 'posto':
      case 'salva-vidas':
        return 'Posto Salva-vidas';
      case 'quiosque':
        return 'Quiosque';
      case 'estacionamento':
        return 'Estacionamento';
      default:
        return tipo;
    }
  }
}

/// Utilitários gerais
class AppUtils {
  /// Formata coordenadas de forma compacta
  static String formatCoordinates(double lat, double lng) {
    return '${lat.toStringAsFixed(4)}°, ${lng.toStringAsFixed(4)}°';
  }

  /// Aplica debounce a uma função
  static void debounce(
    Duration duration,
    VoidCallback action,
    Timer? timer,
  ) {
    timer?.cancel();
    timer = Timer(duration, action);
  }
}