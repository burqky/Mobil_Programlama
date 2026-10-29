import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../data/app_state_data.dart';
import '../models/assigned_exercise.dart';

class DailyProgramTab extends StatefulWidget {
  const DailyProgramTab({super.key});

  @override
  State<DailyProgramTab> createState() => _DailyProgramTabState();
}

class _DailyProgramTabState extends State<DailyProgramTab> {
  late String _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = AppStateData.weekDays.first;
  }

  // Hareketi tamamlama ve ağırlık/süre kaydetme penceresi
  void _completeExerciseDialog(AssignedExercise item) {
    final TextEditingController valCtrl = TextEditingController(
      text: item.targetValue.toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(item.exercise.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Geçen Hafta: ${item.lastWeekValue.toStringAsFixed(0)} ${item.exercise.unitLabel}  •  Hedef: ${item.targetValue.toStringAsFixed(0)} ${item.exercise.unitLabel}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: valCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Bugünkü Değer (${item.exercise.unitLabel})',
                  hintText: 'Örn: ${item.targetValue.toStringAsFixed(0)}',
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Vazgeç'),
            ),
            ElevatedButton(
              onPressed: () {
                // Sayısal dönüşüm için try-catch-finally kullanımı
                try {
                  final double entered = double.parse(
                    valCtrl.text.trim().replaceAll(',', '.'),
                  );

                  if (entered <= 0) return;

                  // Hareketi tamamlandı olarak işaretliyoruz (aktif listeden düşer)
                  setState(() {
                    item.completedWithValue = entered;
                  });
                  Navigator.pop(dialogContext);

                  // Geçen hafta veya hedefin altında kalındıysa uyarı veriyoruz
                  if (entered < item.lastWeekValue || entered < item.targetValue) {
                    final String msg =
                        '${item.exercise.name} (${entered.toStringAsFixed(0)} ${item.exercise.unitLabel}), hedefinizin (${item.targetValue.toStringAsFixed(0)} ${item.exercise.unitLabel}) veya geçen haftanın (${item.lastWeekValue.toStringAsFixed(0)} ${item.exercise.unitLabel}) gerisinde kaldı.';

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(msg),
                        backgroundColor: Colors.red,
                      ),
                    );

                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Performans Uyarısı'),
                        content: Text(msg),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Tamam'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${item.exercise.name} tamamlandı.'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lütfen geçerli bir sayı giriniz!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } finally {
                  debugPrint('Tamamlama işlemi kontrol edildi.');
                }
              },
              child: const Text('Tamamla'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeList = AppStateData.assignedExercises
        .where((e) => e.day == _selectedDay && !e.isCompleted)
        .toList();
    final completedList = AppStateData.assignedExercises
        .where((e) => e.day == _selectedDay && e.isCompleted)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Yatay gün seçimi
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: AppStateData.weekDays.map((day) {
                final bool selected = day == _selectedDay;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => setState(() => _selectedDay = day),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primary : AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        day,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.normal,
                          color: selected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // Günün hareketleri (Tek ve ferah kaydırılabilir liste)
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Gün başlığı ve özet
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStateData.dayFocusMap[_selectedDay] ?? _selectedDay,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${activeList.length} Yapılacak',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Yapılacak aktif hareketler
              if (activeList.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Bugün için bekleyen hareket yok.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                )
              else
                ...activeList.map((item) {
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
                      trailing: ElevatedButton.icon(
                        onPressed: () => _completeExerciseDialog(item),
                        icon: const Icon(Icons.check, size: 16),
                        label: const Text('Tamamla'),
                      ),
                    ),
                  );
                }),

              // Tamamlanan hareketler (Üstü çizili)
              if (completedList.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Tamamlananlar',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                ...completedList.map((item) {
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
                      trailing: IconButton(
                        tooltip: 'Geri Al',
                        icon: const Icon(Icons.undo, size: 20),
                        onPressed: () {
                          setState(() {
                            item.isCompleted = false;
                            item.currentValue = null;
                          });
                        },
                      ),
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
