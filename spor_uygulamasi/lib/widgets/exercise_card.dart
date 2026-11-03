import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/assigned_exercise.dart';

/// Günün programında aktif ve tamamlanan hareketleri gösteren özel kart widget'ı
class ExerciseCard extends StatelessWidget {
  final AssignedExercise item;
  final VoidCallback onActionPressed;
  final bool isReadOnly;

  const ExerciseCard({
    super.key,
    required this.item,
    required this.onActionPressed,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    // Henüz tamamlanmamış hareket kartı
    if (!item.isCompleted) {
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          title: Text(
            item.exercise.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            '${item.exercise.region} • ${item.exercise.sets}\nGeçen: ${item.lastWeekValue.toStringAsFixed(0)} ${item.exercise.unitLabel}  |  Hedef: ${item.targetValue.toStringAsFixed(0)} ${item.exercise.unitLabel}',
            style: const TextStyle(fontSize: 12),
          ),
          isThreeLine: true,
          trailing: isReadOnly
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.visibility_outlined,
                        size: 15,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Göz Atma',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : ElevatedButton.icon(
                  onPressed: onActionPressed,
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
        subtitle: Text(
          'Yapılan: ${(item.currentValue ?? 0).toStringAsFixed(0)} ${item.exercise.unitLabel} (Hedef: ${item.targetValue.toStringAsFixed(0)} ${item.exercise.unitLabel})',
          style: TextStyle(
            fontSize: 12,
            color: warn ? AppColors.error : AppColors.textSecondary,
          ),
        ),
        trailing: isReadOnly
            ? const Text(
                'Tamamlandı',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              )
            : OutlinedButton.icon(
                onPressed: onActionPressed,
                icon: const Icon(Icons.replay_rounded, size: 16),
                label: const Text('Tekrarla'),
              ),
      ),
    );
  }
}
