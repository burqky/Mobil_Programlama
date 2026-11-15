import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../data/app_state_data.dart';
import '../models/assigned_exercise.dart';
import '../models/catalog_exercise.dart';
import '../widgets/day_selector_bar.dart';

class WeeklyProgramTab extends StatefulWidget {
  const WeeklyProgramTab({super.key});

  @override
  State<WeeklyProgramTab> createState() => _WeeklyProgramTabState();
}

class _WeeklyProgramTabState extends State<WeeklyProgramTab> {
  String _selectedDay = AppStateData.weekDays.first;
  // Tıklanarak detayları açılan hareketlerin ID listesi (1. Hafta PDF: List, indexOf, add, removeAt)
  final List<String> _expandedExerciseIds = [];

  // Havuzdan seçilen hareketi güne ekleme (5. Hafta PDF Syf 21-27: SimpleDialog & SimpleDialogOption)
  void _showAddFromCatalogDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        List<Widget> secenekler = [];

        // 1. Hafta PDF Syf 75: for-in döngüsü ile havuzdaki hareketleri SimpleDialogOption olarak ekleme
        for (CatalogExercise ex in AppStateData.catalogExercises) {
          secenekler.add(
            SimpleDialogOption(
              onPressed: () {
                setState(() {
                  AppStateData.assignedExercises.add(
                    AssignedExercise.fromCatalog(
                      id: 'asg_${DateTime.now().millisecondsSinceEpoch}',
                      exercise: ex,
                      day: _selectedDay,
                    ),
                  );
                });
                Navigator.pop(dialogContext);

                final snackBar = SnackBar(
                  duration: const Duration(seconds: 3),
                  content: Text('${ex.name} $_selectedDay gününe eklendi.'),
                  backgroundColor: AppColors.success,
                  action: SnackBarAction(
                    textColor: Colors.white,
                    label: 'TAMAM',
                    onPressed: () {},
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  ex.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          );
        }

        // 5. Hafta PDF Syf 26 (Uygulama-26): İptal seçeneği
        secenekler.add(
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Text(
                'İptal',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );

        return SimpleDialog(
          title: Text('$_selectedDay Gününe Ekle'),
          children: secenekler,
        );
      },
    );
  }

  // Hedef ağırlık/süre düzenleme penceresi (5. Hafta PDF Syf 19: AlertDialog kalıbı)
  void _editTargetDialog(AssignedExercise item) {
    final lastWeekCtrl = TextEditingController(
      text: item.lastWeekValue.toStringAsFixed(0),
    );
    final targetCtrl = TextEditingController(
      text: item.targetValue.toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        Widget iptalButonu = TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('İptal'),
        );

        Widget kaydetButonu = ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            // 1. Hafta PDF Syf 95 & 2. Hafta PDF Syf 50-51: try - on FormatException catch - finally
            try {
              final double lw = double.parse(lastWeekCtrl.text.trim());
              final double tg = double.parse(targetCtrl.text.trim());
              setState(() {
                item.lastWeekValue = lw;
                item.targetValue = tg;
              });
              Navigator.pop(dialogContext);
            } on FormatException catch (e) {
              debugPrint('Sayısal dönüşüm hatası: $e');
              final snackBar = SnackBar(
                duration: const Duration(seconds: 3),
                content: const Text('Lütfen geçerli bir sayı giriniz!'),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  textColor: Colors.white,
                  label: 'TAMAM',
                  onPressed: () {},
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } catch (e) {
              debugPrint('Beklenmeyen hata: $e');
            } finally {
              debugPrint('Hedef güncelleme kontrolü tamamlandı.');
            }
          },
          child: const Text('Kaydet'),
        );

        AlertDialog alert = AlertDialog(
          title: Text(item.exercise.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: lastWeekCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Geçen Hafta (${item.exercise.unitLabel})',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: targetCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Hedef (${item.exercise.unitLabel})',
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [iptalButonu, kaydetButonu],
        );

        return alert;
      },
    );
  }

  // 1. Hafta PDF Syf 40-42 (Uygulama-12): indexOf ve removeAt kullanarak silme
  void _deleteAssignedExercise(AssignedExercise item) {
    setState(() {
      final int index = AppStateData.assignedExercises.indexOf(item);
      if (index != -1) {
        AppStateData.assignedExercises.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Hafta PDF Syf 41 & 75: for-in döngüsü ve add() ile seçili günün listesini oluşturma
    List<AssignedExercise> dayExercises = [];
    for (AssignedExercise item in AppStateData.assignedExercises) {
      if (item.day == _selectedDay) {
        dayExercises.add(item);
      }
    }

    return Column(
      children: [
        // Yatay gün seçici (lib/widgets/day_selector_bar.dart)
        DaySelectorBar(
          days: AppStateData.weekDays,
          selectedDay: _selectedDay,
          onDaySelected: (String day) {
            setState(() {
              _selectedDay = day;
            });
          },
        ),

        // Üst aksiyon butonları (4. Hafta PDF: OutlinedButton, ElevatedButton.icon; 10. Hafta PDF: pushNamed)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/catalog');
                    setState(() {});
                  },
                  child: const Text('Tüm Hareketlerim'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: _showAddFromCatalogDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Güne Hareket Ekle'),
                ),
              ),
            ],
          ),
        ),

        // Seçili günün hareket listesi (6. Hafta PDF Syf 7-13: ListView.builder)
        Expanded(
          child: dayExercises.isEmpty
              ? const Center(
                  child: Text(
                    'Bu güne henüz hareket eklenmemiş.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: dayExercises.length,
                  itemBuilder: (context, index) {
                    final item = dayExercises[index];
                    final int expandedIdx = _expandedExerciseIds.indexOf(
                      item.id,
                    );
                    final bool isExpanded = expandedIdx != -1;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            if (isExpanded) {
                              _expandedExerciseIds.removeAt(expandedIdx);
                            } else {
                              _expandedExerciseIds.add(item.id);
                            }
                          });
                        },
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.background,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        title: Text(
                          item.exercise.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: isExpanded
                            ? Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  '${item.exercise.region} • ${item.exercise.sets}\nGeçen: ${item.lastWeekValue.toStringAsFixed(0)} ${item.exercise.unitLabel}  |  Hedef: ${item.targetValue.toStringAsFixed(0)} ${item.exercise.unitLabel}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              )
                            : null,
                        isThreeLine: isExpanded,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 20),
                              onPressed: () => _editTargetDialog(item),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 20,
                                color: AppColors.error,
                              ),
                              onPressed: () => _deleteAssignedExercise(item),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
