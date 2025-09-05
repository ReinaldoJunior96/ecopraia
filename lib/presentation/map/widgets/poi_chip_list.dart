import 'package:flutter/material.dart';
import 'package:ecopraia/data/models/poi.dart';
import 'package:ecopraia/core/utils.dart';

/// Lista de chips para exibir POIs de uma praia
class PoiChipList extends StatelessWidget {
  final List<Poi> pois;
  final Set<String> selectedFilters;
  final Function(String)? onFilterToggle;

  const PoiChipList({
    Key? key,
    required this.pois,
    this.selectedFilters = const {},
    this.onFilterToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (pois.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Nenhum POI disponível',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
        ),
      );
    }

    // Agrupa POIs por tipo
    final Map<String, List<Poi>> poisByType = {};
    for (final poi in pois) {
      poisByType.putIfAbsent(poi.tipo, () => []).add(poi);
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: poisByType.entries.map((entry) {
        final tipo = entry.key;
        final poisCount = entry.value.length;
        final isSelected = selectedFilters.contains(tipo);

        return FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                PoiUtils.getPoiIcon(tipo),
                size: 16,
                color: PoiUtils.getPoiIconColor(tipo, context),
              ),
              const SizedBox(width: 4),
              Text(
                '${PoiUtils.getPoiDisplayName(tipo)} ($poisCount)',
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : null,
                ),
              ),
            ],
          ),
          selected: isSelected,
          onSelected: onFilterToggle != null
              ? (selected) => onFilterToggle!(tipo)
              : null,
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          selectedColor: Theme.of(context).colorScheme.primary,
          checkmarkColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      }).toList(),
    );
  }
}

/// Lista de chips para filtros de POI no topo do mapa
class PoiFilterChips extends StatelessWidget {
  final Set<String> selectedFilters;
  final Function(String) onFilterToggle;
  final VoidCallback onClearFilters;

  const PoiFilterChips({
    Key? key,
    required this.selectedFilters,
    required this.onFilterToggle,
    required this.onClearFilters,
  }) : super(key: key);

  static const List<String> _allPoiTypes = [
    'banheiro',
    'ducha',
    'lixeira',
    'posto',
    'quiosque',
    'estacionamento',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Chip para limpar filtros
            if (selectedFilters.isNotEmpty) ...[
              ActionChip(
                label: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.clear_all, size: 16, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'Limpar',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                backgroundColor: Colors.red,
                onPressed: onClearFilters,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(width: 8),
            ],

            // Chips de filtro
            ..._allPoiTypes.map((tipo) {
              final isSelected = selectedFilters.contains(tipo);

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        PoiUtils.getPoiIcon(tipo),
                        size: 16,
                        color: isSelected
                            ? Colors.white
                            : PoiUtils.getPoiIconColor(tipo, context),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        PoiUtils.getPoiDisplayName(tipo),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : null,
                        ),
                      ),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (selected) => onFilterToggle(tipo),
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  selectedColor: Theme.of(context).colorScheme.primary,
                  checkmarkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.withOpacity(0.3),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
