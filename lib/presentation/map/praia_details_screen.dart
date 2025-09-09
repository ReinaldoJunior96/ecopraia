import 'package:flutter/material.dart';
import 'package:ecopraia/data/models/praia.dart';

class PraiaDetailsScreen extends StatelessWidget {
  final Praia praia;

  const PraiaDetailsScreen({Key? key, required this.praia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(praia.nome),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (praia.imagemCapa.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  praia.imagemCapa,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image,
                        size: 200, color: Colors.grey);
                  },
                ),
              ),
            const SizedBox(height: 16),
            Text(
              praia.descricao,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Text(
              'Avaliações: ${praia.mediaNotas} (${praia.totalAvaliacoes} avaliações)',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Text(
              'Bairro: ${praia.bairro}',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Text(
              'Status: ${praia.status}',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Text(
              'Categoria: ${praia.categoria}',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            if (praia.tags.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tags',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: praia.tags
                        .map((tag) => Chip(
                              label: Text(tag),
                              backgroundColor: Colors.teal.shade100,
                            ))
                        .toList(),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            if (praia.pois.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pontos de Interesse',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...praia.pois.map((poi) => ListTile(
                        leading: const Icon(Icons.place, color: Colors.teal),
                        title: Text(poi.tipo),
                        subtitle: Text(poi.descricao ?? 'Sem descrição'),
                      )),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
