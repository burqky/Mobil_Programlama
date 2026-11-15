import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../data/app_state_data.dart';
import '../models/assigned_exercise.dart';
import '../widgets/exercise_card.dart';

class DailyProgramTab extends StatefulWidget {
  const DailyProgramTab({super.key});

  @override
  State<DailyProgramTab> createState() => _DailyProgramTabState();
}

class _DailyProgramTabState extends State<DailyProgramTab> {
  String _todayDay = '';

  @override
  void initState() {
    super.initState();
    // 4. Hafta PDF Syf 27 (initState): Sistemde bugün hangi günse otomatik yüklenir
    _todayDay = AppStateData.todayName;
  }

  // Hareketi tamamlama ve ağırlık/süre kaydetme penceresi (5. Hafta PDF Syf 19: Uygulama-25)
  void _completeExerciseDialog(AssignedExercise item) {
    final TextEditingController valCtrl = TextEditingController(
      text: item.targetValue.toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        Widget vazgecButonu = TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Vazgeç'),
        );

        Widget tamamlaButonu = ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            // 1. Hafta PDF Syf 95 & 2. Hafta PDF Syf 50-51: try - on FormatException catch - finally
            try {
              final double entered = double.parse(valCtrl.text.trim());

              if (entered <= 0) return;

              // Madde b: Hareketi tamamlandı olarak işaretliyoruz (aktif listeden düşer)
              setState(() {
                item.completedWithValue = entered;
              });
              Navigator.pop(dialogContext);

              // Madde c: Geçen hafta veya hedefin altında kalındıysa uyarı veriyoruz
              if (entered < item.lastWeekValue || entered < item.targetValue) {
                final String msg =
                    '${item.exercise.name} (${entered.toStringAsFixed(0)} ${item.exercise.unitLabel}), hedefinizin (${item.targetValue.toStringAsFixed(0)} ${item.exercise.unitLabel}) veya geçen haftanın (${item.lastWeekValue.toStringAsFixed(0)} ${item.exercise.unitLabel}) gerisinde kaldı.';

                // 5. Hafta PDF Syf 29-33 (Uygulama-27): SnackBar ve SnackBarAction
                final snackBar = SnackBar(
                  duration: const Duration(seconds: 3),
                  content: Text(msg),
                  backgroundColor: Colors.red,
                  action: SnackBarAction(
                    textColor: Colors.white,
                    label: 'TAMAM',
                    onPressed: () {},
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                showDialog(
                  context: context,
                  builder: (BuildContext ctx) {
                    Widget tamamButonu = TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Tamam'),
                    );
                    AlertDialog uyari = AlertDialog(
                      title: const Text('Performans Uyarısı'),
                      content: Text(msg),
                      actions: [tamamButonu],
                    );
                    return uyari;
                  },
                );
              } else {
                final snackBar = SnackBar(
                  duration: const Duration(seconds: 3),
                  content: Text('${item.exercise.name} tamamlandı.'),
                  backgroundColor: AppColors.success,
                  action: SnackBarAction(
                    textColor: Colors.white,
                    label: 'TAMAM',
                    onPressed: () {},
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            } on FormatException catch (e) {
              debugPrint('Sayısal dönüşüm hatası: $e');
              final hataSnackBar = SnackBar(
                duration: const Duration(seconds: 3),
                content: const Text('Lütfen geçerli bir sayı giriniz!'),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  textColor: Colors.white,
                  label: 'TAMAM',
                  onPressed: () {},
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(hataSnackBar);
            } catch (e) {
              debugPrint('Beklenmeyen hata: $e');
            } finally {
              debugPrint('Tamamlama işlemi kontrol edildi.');
            }
          },
          child: const Text('Tamamla'),
        );

        AlertDialog alert = AlertDialog(
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
          actions: [vazgecButonu, tamamlaButonu],
        );

        return alert;
      },
    );
  }

  // Tamamlanan bir hareketi tekrar yapılacaklar listesine alır
  void _repeatExercise(AssignedExercise item) {
    setState(() {
      item.isCompleted = false;
      item.currentValue = null;
    });

    final snackBar = SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(
        '${item.exercise.name} tekrar yapılacaklar listesine alındı.',
      ),
      backgroundColor: AppColors.primary,
      action: SnackBarAction(
        textColor: Colors.white,
        label: 'TAMAM',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    // 1. Hafta PDF Syf 41 & 75: for-in döngüsü ve add() ile günün aktif/tamamlanan hareketlerini ayırma
    List<AssignedExercise> activeList = [];
    List<AssignedExercise> completedList = [];

    for (AssignedExercise item in AppStateData.assignedExercises) {
      if (item.day == _todayDay) {
        if (item.isCompleted) {
          completedList.add(item);
        } else {
          activeList.add(item);
        }
      }
    }

    List<Widget> listeElemanlari = [];
    listeElemanlari.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              AppStateData.dayFocusMap[_todayDay] ?? _todayDay,
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
    );
    listeElemanlari.add(const SizedBox(height: 12));

    if (activeList.isEmpty) {
      listeElemanlari.add(
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Bugün için bekleyen hareket yok.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ),
      );
    } else {
      for (AssignedExercise item in activeList) {
        listeElemanlari.add(
          ExerciseCard(
            item: item,
            onActionPressed: () {
              _completeExerciseDialog(item);
            },
          ),
        );
      }
    }

    if (completedList.isNotEmpty) {
      listeElemanlari.add(const SizedBox(height: 16));
      listeElemanlari.add(
        const Text(
          'Tamamlananlar',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      );
      listeElemanlari.add(const SizedBox(height: 8));
      for (AssignedExercise item in completedList) {
        listeElemanlari.add(
          ExerciseCard(
            item: item,
            onActionPressed: () {
              _repeatExercise(item);
            },
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Üst Gün Bilgisi Barı
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.today_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                _todayDay,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),

        // Günün hareketleri listesi (6. Hafta PDF: ListView)
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: listeElemanlari,
          ),
        ),
      ],
    );
  }
}
