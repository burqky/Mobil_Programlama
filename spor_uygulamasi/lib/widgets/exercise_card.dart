import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/assigned_exercise.dart';

/// Günün programında aktif ve tamamlanan hareketleri gösteren özel kart widget'ı
/// Karta tıklandığında detaylar (subtitle) açılıp kapanır (Progressive Disclosure)
class ExerciseCard extends StatefulWidget {
  final AssignedExercise item;
  final VoidCallback onActionPressed;

  const ExerciseCard({
    super.key,
    required this.item,
    required this.onActionPressed,
  });

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  // Varsayılan olarak detaylar gizlidir, kullanıcı tıklayınca gösterilir
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    // Henüz tamamlanmamış hareket kartı
    if (!item.isCompleted) {
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          onTap: () {
            setState(() {
              _showDetails = !_showDetails;
            });
          },
          title: Text(
            item.exercise.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: _showDetails
              ? Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${item.exercise.region} • ${item.exercise.sets}\nGeçen: ${item.lastWeekValue.toStringAsFixed(0)} ${item.exercise.unitLabel}  |  Hedef: ${item.targetValue.toStringAsFixed(0)} ${item.exercise.unitLabel}',
                    style: const TextStyle(fontSize: 12),
                  ),
                )
              : null,
          isThreeLine: _showDetails,
          trailing: ElevatedButton.icon(
            onPressed: widget.onActionPressed,
            icon: const Icon(Icons.check, size: 16),
            label: const Text('Tamamla'),
          ),
        ),
      );
    }

    // Tamamlanmış hareket kartı ("Tekrarla" butonu ile)
    final bool warn = item.hasPerformanceWarning;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: () {
          setState(() {
            _showDetails = !_showDetails;
          });
        },
        leading: Icon(
          warn ? Icons.warning_amber_rounded : Icons.check_circle,
          color: warn ? AppColors.error : AppColors.success,
        ),
        title: Text(
          item.exercise.name,
          style: const TextStyle(
            decoration: TextDecoration.lineThrough,
            color: AppColors.textSecondary,
          ),
        ),
        subtitle: _showDetails
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Yapılan: ${(item.currentValue ?? 0).toStringAsFixed(0)} ${item.exercise.unitLabel}  |  Hedef: ${item.targetValue.toStringAsFixed(0)} ${item.exercise.unitLabel}',
                  style: TextStyle(
                    fontSize: 12,
                    color: warn ? AppColors.error : AppColors.textSecondary,
                  ),
                ),
              )
            : null,
        trailing: OutlinedButton.icon(
          onPressed: widget.onActionPressed,
          icon: const Icon(Icons.replay_rounded, size: 16),
          label: const Text('Tekrarla'),
        ),
      ),
    );
  }
}
