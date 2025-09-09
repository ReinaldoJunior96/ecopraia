import 'package:ecopraia/data/models/poi.dart';

/// Modelo de dados para uma praia
class Praia {
  final int id;
  final String nome;
  final double lat;
  final double lng;
  final String status; // 'segura', 'atenção', 'risco', 'sem dados'
  final String bairro;
  final String descricao; // Alterado para ser obrigatório
  final String categoria; // 'praia', 'bombeiro', etc
  final List<Poi> pois;
  final double mediaNotas;
  final int totalAvaliacoes;
  final bool acessibilidade;
  final List<String> tags;
  final String imagemCapa;
  final DateTime atualizadoEm;

  Praia({
    required this.id,
    required this.nome,
    required this.lat,
    required this.lng,
    required this.status,
    required this.bairro,
    required this.descricao,
    required this.categoria,
    required this.pois,
    required this.mediaNotas,
    required this.totalAvaliacoes,
    required this.acessibilidade,
    required this.tags,
    required this.imagemCapa,
    required this.atualizadoEm,
  });

  /// Cria uma praia a partir de um mapa JSON
  factory Praia.fromJson(Map<String, dynamic> json) {
    return Praia(
      id: json['id'] as int,
      nome: json['nome'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      status: json['status'] as String,
      bairro: json['bairro'] as String,
      descricao: json['descricao'] as String,
      categoria: json['categoria'] as String? ?? 'praia',
      pois: (json['pois'] as List<dynamic>?)
              ?.map((poi) => Poi.fromJson(poi as Map<String, dynamic>))
              .toList() ??
          [],
      mediaNotas: (json['mediaNotas'] as num).toDouble(),
      totalAvaliacoes: json['totalAvaliacoes'] as int,
      acessibilidade: json['acessibilidade'] as bool,
      tags:
          (json['tags'] as List<dynamic>).map((tag) => tag as String).toList(),
      imagemCapa: json['imagemCapa'] as String,
      atualizadoEm: DateTime.parse(json['atualizadoEm'] as String),
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
      'mediaNotas': mediaNotas,
      'totalAvaliacoes': totalAvaliacoes,
      'acessibilidade': acessibilidade,
      'tags': tags,
      'imagemCapa': imagemCapa,
      'atualizadoEm': atualizadoEm.toIso8601String(),
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
    double? mediaNotas,
    int? totalAvaliacoes,
    bool? acessibilidade,
    List<String>? tags,
    String? imagemCapa,
    DateTime? atualizadoEm,
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
      mediaNotas: mediaNotas ?? this.mediaNotas,
      totalAvaliacoes: totalAvaliacoes ?? this.totalAvaliacoes,
      acessibilidade: acessibilidade ?? this.acessibilidade,
      tags: tags ?? this.tags,
      imagemCapa: imagemCapa ?? this.imagemCapa,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
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
