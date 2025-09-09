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
            // Imagem da praia
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

            // Descrição
            Text(
              praia.descricao,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),

            // Avaliações
            Text(
              'Avaliações',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRatingRow('🧹 Limpeza', praia.mediaNotas),
                _buildRatingRow('💧 Água', praia.mediaNotas),
                _buildRatingRow('🛟 Segurança', praia.mediaNotas),
                _buildRatingRow('🏖️ Estrutura', praia.mediaNotas),
                _buildRatingRow('🌅 Beleza', praia.mediaNotas),
              ],
            ),
            const SizedBox(height: 16),

            // Pontos de interesse
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

  Widget _buildRatingRow(String label, double rating) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(width: 8),
        Row(
          children: List.generate(5, (index) {
            if (index < rating.floor()) {
              return const Icon(Icons.star, color: Colors.yellow, size: 20);
            } else if (index < rating) {
              return const Icon(Icons.star_half,
                  color: Colors.yellow, size: 20);
            } else {
              return const Icon(Icons.star_border,
                  color: Colors.yellow, size: 20);
            }
          }),
        ),
      ],
    );
  }
}
