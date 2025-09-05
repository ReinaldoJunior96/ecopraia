import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ecopraia/data/models/praia.dart';
import 'package:ecopraia/core/utils.dart';
import 'package:ecopraia/services/map_service.dart';
import 'package:ecopraia/presentation/map/widgets/status_badge.dart';
import 'package:ecopraia/presentation/map/widgets/poi_chip_list.dart';

/// Bottom sheet que exibe detalhes de uma praia
class PraiaBottomSheet extends StatefulWidget {
  final Praia praia;
  final VoidCallback onClose;

  const PraiaBottomSheet({
    Key? key,
    required this.praia,
    required this.onClose,
  }) : super(key: key);

  @override
  State<PraiaBottomSheet> createState() => _PraiaBottomSheetState();
}

class _PraiaBottomSheetState extends State<PraiaBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
              0, MediaQuery.of(context).size.height * _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle do drag
            Container(
              margin: const EdgeInsets.only(top: 8),
              alignment: Alignment.center,
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Conteúdo principal
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header com nome e status
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.praia.nome,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            if (widget.praia.bairro != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                widget.praia.bairro!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.grey,
                                    ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      StatusBadge(status: widget.praia.status),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Coordenadas
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppUtils.formatCoordinates(
                            widget.praia.lat, widget.praia.lng),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),

                  // Descrição (se houver)
                  if (widget.praia.descricao != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      widget.praia.descricao!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],

                  const SizedBox(height: 20),

                  // POIs
                  if (widget.praia.pois.isNotEmpty) ...[
                    Text(
                      'Pontos de Interesse',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    PoiChipList(pois: widget.praia.pois),
                    const SizedBox(height: 20),
                  ],

                  // Botões de ação
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: widget.onClose,
                          icon: const Icon(Icons.close, size: 18),
                          label: const Text('Fechar'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _openGoogleMaps(),
                          icon: const Icon(Icons.directions, size: 18),
                          label: const Text('Como chegar'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Espaçamento para safe area
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  /// Abre o Google Maps com as coordenadas da praia
  Future<void> _openGoogleMaps() async {
    final url = MapService.generateGoogleMapsUrl(
      widget.praia.lat,
      widget.praia.lng,
      label: widget.praia.nome,
    );

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Não foi possível abrir o Google Maps'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao abrir o mapa: ${e.toString()}'),
          ),
        );
      }
    }
  }
}

/// Função utilitária para mostrar o bottom sheet
void showPraiaBottomSheet(
  BuildContext context,
  Praia praia,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => PraiaBottomSheet(
      praia: praia,
      onClose: () => Navigator.of(context).pop(),
    ),
  );
}
