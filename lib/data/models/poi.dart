/// Modelo de dados para um POI (Point of Interest)
class Poi {
  final int id;
  final String tipo;
  final double lat;
  final double lng;
  final String? descricao;

  Poi({
    required this.id,
    required this.tipo,
    required this.lat,
    required this.lng,
    this.descricao,
  });

  /// Cria um POI a partir de um mapa JSON
  factory Poi.fromJson(Map<String, dynamic> json) {
    return Poi(
      id: json['id'] as int,
      tipo: json['tipo'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      descricao: json['descricao'] as String?,
    );
  }

  /// Converte o POI para um mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo,
      'lat': lat,
      'lng': lng,
      'descricao': descricao,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Poi && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Poi(id: $id, tipo: $tipo, lat: $lat, lng: $lng, descricao: $descricao)';
  }
}
