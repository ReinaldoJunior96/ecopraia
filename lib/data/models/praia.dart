import 'package:ecopraia/data/models/poi.dart';

/// Modelo de dados para uma praia
class Praia {
  final int id;
  final String nome;
  final double lat;
  final double lng;
  final String status; // 'segura', 'atenção', 'risco', 'sem dados'
  final String? bairro;
  final String? descricao;
  final String categoria; // 'praia', 'bombeiro', etc
  final List<Poi> pois;

  Praia({
    required this.id,
    required this.nome,
    required this.lat,
    required this.lng,
    required this.status,
    this.bairro,
    this.descricao,
    required this.categoria,
    required this.pois,
  });

  /// Cria uma praia a partir de um mapa JSON
  factory Praia.fromJson(Map<String, dynamic> json) {
    return Praia(
      id: json['id'] as int,
      nome: json['nome'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      status: json['status'] as String,
      bairro: json['bairro'] as String?,
      descricao: json['descricao'] as String?,
      categoria: json['categoria'] as String? ?? 'praia',
      pois: (json['pois'] as List<dynamic>?)
              ?.map((poi) => Poi.fromJson(poi as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Converte a praia para um mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'lat': lat,
      'lng': lng,
      'status': status,
      'bairro': bairro,
      'descricao': descricao,
      'categoria': categoria,
      'pois': pois.map((poi) => poi.toJson()).toList(),
    };
  }

  /// Cria uma cópia da praia com alguns campos modificados
  Praia copyWith({
    int? id,
    String? nome,
    double? lat,
    double? lng,
    String? status,
    String? bairro,
    String? descricao,
    String? categoria,
    List<Poi>? pois,
  }) {
    return Praia(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      status: status ?? this.status,
      bairro: bairro ?? this.bairro,
      descricao: descricao ?? this.descricao,
      categoria: categoria ?? this.categoria,
      pois: pois ?? this.pois,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Praia && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Praia(id: $id, nome: $nome, status: $status, bairro: $bairro)';
  }
}
