import 'package:flutter/material.dart';
import 'package:ecopraia/core/utils.dart';

/// Badge que exibe o status da praia com cor e texto
class StatusBadge extends StatelessWidget {
  final String status;
  final EdgeInsets? padding;

  const StatusBadge({
    Key? key,
    required this.status,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = BeachStatusUtils.getStatusColor(status, isDark: isDark);
    final statusText = BeachStatusUtils.getStatusText(status);
    final statusEmoji = BeachStatusUtils.getStatusEmoji(status);

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            statusEmoji,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}