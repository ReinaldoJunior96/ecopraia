import 'dart:math';
import 'package:flutter/material.dart';
// ...existing code...
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// Serviço com utilitários para mapas (OpenStreetMap)
class MapService {
  /// Configuração padrão do mapa (São Luís - MA)
  static const double defaultCenterLat = -2.53;
  static const double defaultCenterLng = -44.28;
  static const double defaultZoom = 12.0;

  /// Calcula a bounding box baseada na posição e zoom da câmera
  static Map<String, double> calculateBoundingBox(
    LatLng center,
    double zoom,
  ) {
    final double latDelta = 0.01 * (16 - zoom);
    final double lngDelta = 0.01 * (16 - zoom);
    return {
      'minLat': center.latitude - latDelta,
      'maxLat': center.latitude + latDelta,
      'minLng': center.longitude - lngDelta,
      'maxLng': center.longitude + lngDelta,
    };
  }

  /// Calcula a distância entre dois pontos em metros
  static double calculateDistance(
    LatLng point1,
    LatLng point2,
  ) {
    return Geolocator.distanceBetween(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    );
  }

  /// Verifica se um ponto está dentro de uma bounding box
  static bool isPointInBounds(
    LatLng point,
    double minLat,
    double maxLat,
    double minLng,
    double maxLng,
  ) {
    return point.latitude >= minLat &&
        point.latitude <= maxLat &&
        point.longitude >= minLng &&
        point.longitude <= maxLng;
  }

  /// Gera uma URL do Google Maps para navegação (mantido para abrir navegação externa)
  static String generateGoogleMapsUrl(
    double lat,
    double lng, {
    String? label,
  }) {
    final String query = label != null ? '$label@$lat,$lng' : '$lat,$lng';
    return 'https://www.google.com/maps/search/?api=1&query=$query';
  }

  /// Solicita permissões de localização
  static Future<LocationPermission> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission;
  }

  /// Obtém a localização atual do usuário
  static Future<Position?> getCurrentLocation() async {
    final LocationPermission permission = await requestLocationPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      return null;
    }
  }
}
