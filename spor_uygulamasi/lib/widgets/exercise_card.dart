import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/assigned_exercise.dart';

/// Günün programında aktif ve tamamlanan hareketleri gösteren kart widget'ı
/// 3. Hafta PDF (TextDecoration.lineThrough), 4. Hafta PDF (ElevatedButton.icon, OutlinedButton), 5. Hafta PDF (Card, ListTile)
class ExerciseCard extends StatefulWidget {
  final AssignedExercise item;
  // 2. Hafta PDF Syf 24: Parametre olarak Function tipi kullanımı
  final Function onActionPressed;

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

    // Henüz tamamlanmamış hareket kartı (Madde b: aktif listede gösterilir)
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
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              widget.onActionPressed();
            },
            icon: const Icon(Icons.check, size: 16),
            label: const Text('Tamamla'),
          ),
        ),
      );
    }

    // Tamamlanmış hareket kartı (3. Hafta PDF Syf 11: TextDecoration.lineThrough ile üstü çizili)
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
        trailing: OutlinedButton(
          onPressed: () {
            widget.onActionPressed();
          },
          child: const Text('Tekrarla'),
        ),
      ),
    );
  }
}
