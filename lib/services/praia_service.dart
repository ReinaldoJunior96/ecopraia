import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecopraia/core/env.dart';
import 'package:ecopraia/data/models/praia.dart';

class PraiaService {
  final String baseUrl =
      'https://wfistdaghosylsxdpqyu.supabase.co/rest/v1/praias';

  Future<List<Praia>> fetchPraias() async {
    final response = await http.get(
      Uri.parse('$baseUrl?select=*'),
      headers: {
        'apikey': Env.supabaseApiKey,
        'Authorization': 'Bearer ${Env.supabaseApiKey}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Praia.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load praias: ${response.reasonPhrase}');
    }
  }

  Future<Praia> fetchPraiaById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl?id=eq.$id&select=*'),
      headers: {
        'apikey': Env.supabaseApiKey,
        'Authorization': 'Bearer ${Env.supabaseApiKey}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        return Praia.fromJson(data.first);
      } else {
        throw Exception('Praia não encontrada.');
      }
    } else {
      throw Exception('Erro ao buscar praia: ${response.reasonPhrase}');
    }
  }
}
