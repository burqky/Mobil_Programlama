import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../data/app_state_data.dart';
import '../models/assigned_exercise.dart';
import '../widgets/day_selector_bar.dart';
import '../widgets/exercise_card.dart';

class DailyProgramTab extends StatefulWidget {
  const DailyProgramTab({super.key});

  @override
  State<DailyProgramTab> createState() => _DailyProgramTabState();
}

class _DailyProgramTabState extends State<DailyProgramTab> {
  late final String _todayDay;
  late String _selectedDay;
  bool _showOtherDaysBrowser = false;

  @override
  void initState() {
    super.initState();
    // Sistemde bugün hangi günse otomatik olarak o günün programı yüklenir
    _todayDay = AppStateData.todayName;
    _selectedDay = _todayDay;
  }

  bool get _isViewingToday => _selectedDay == _todayDay;

  // Hareketi tamamlama ve ağırlık/süre kaydetme penceresi (Sadece bugünün hareketleri için)
  void _completeExerciseDialog(AssignedExercise item) {
    if (!_isViewingToday) return;

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
                  if (entered < item.lastWeekValue ||
                      entered < item.targetValue) {
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

  // Tamamlanan bir hareketi tekrar yapılacaklar listesine alır
  void _repeatExercise(AssignedExercise item) {
    if (!_isViewingToday) return;

    setState(() {
      item.isCompleted = false;
      item.currentValue = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${item.exercise.name} tekrar yapılacaklar listesine alındı.',
        ),
        backgroundColor: AppColors.primary,
      ),
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
        // Üst Bilgi ve "Diğer Günlere Göz At" Kontrol Barı (Mobil ekranlara tam uyumlu tek satır düzen)
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _isViewingToday
                      ? Icons.today_rounded
                      : Icons.visibility_outlined,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isViewingToday ? 'Bugünün Programı' : 'İncelenen Gün',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _selectedDay,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: () {
                  setState(() {
                    if (!_isViewingToday) {
                      _selectedDay = _todayDay;
                      _showOtherDaysBrowser = false;
                    } else {
                      _showOtherDaysBrowser = !_showOtherDaysBrowser;
                    }
                  });
                },
                icon: Icon(
                  !_isViewingToday
                      ? Icons.restore_rounded
                      : (_showOtherDaysBrowser
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.calendar_view_week_rounded),
                  size: 16,
                ),
                label: Text(
                  !_isViewingToday
                      ? 'Bugüne Dön'
                      : (_showOtherDaysBrowser
                          ? 'Günleri Gizle'
                          : 'Diğer Günler'),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Kullanıcı "Diğer Günler" butonuna bastığında açılan yatay gün seçici
        if (_showOtherDaysBrowser)
          DaySelectorBar(
            days: AppStateData.weekDays,
            selectedDay: _selectedDay,
            onDaySelected: (day) => setState(() => _selectedDay = day),
          ),

        // Günün hareketleri listesi
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Başka bir güne göz atılıyorsa bilgilendirme kutusu gösterilir
              if (!_isViewingToday)
                Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Şu anda $_selectedDay gününün programına göz atıyorsunuz. Yalnızca bugünün ($_todayDay) hareketleri tamamlanabilir.',
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Gün başlığı ve özet
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      AppStateData.dayFocusMap[_selectedDay] ?? _selectedDay,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${activeList.length} Hareket',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Yapılacak aktif hareketler (lib/widgets/exercise_card.dart)
              if (activeList.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _isViewingToday
                          ? 'Bugün için bekleyen hareket yok.'
                          : '$_selectedDay günü için kayıtlı hareket bulunmuyor.',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                )
              else
                ...activeList.map((item) {
                  return ExerciseCard(
                    item: item,
                    isReadOnly: !_isViewingToday,
                    onActionPressed: () => _completeExerciseDialog(item),
                  );
                }),

              // Tamamlanan hareketler ("Tekrarla" butonu ile)
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
                  return ExerciseCard(
                    item: item,
                    isReadOnly: !_isViewingToday,
                    onActionPressed: () => _repeatExercise(item),
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
