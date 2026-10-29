import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../data/app_state_data.dart';
import '../models/assigned_exercise.dart';
import '../models/catalog_exercise.dart';

class WeeklyProgramTab extends StatefulWidget {
  const WeeklyProgramTab({super.key});

  @override
  State<WeeklyProgramTab> createState() => _WeeklyProgramTabState();
}

class _WeeklyProgramTabState extends State<WeeklyProgramTab> {
  String _selectedDay = AppStateData.weekDays.first;

  // Havuzdan seçilen hareketi güne ekleme (SimpleDialog kullanımı)
  void _showAddFromCatalogDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          title: Text('$_selectedDay Gününe Ekle'),
          children: AppStateData.catalogExercises.map((CatalogExercise ex) {
            return SimpleDialogOption(
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${ex.name} $_selectedDay gününe eklendi.'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${ex.name} (${ex.region})',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text(
                      '${ex.defaultTarget.toStringAsFixed(0)} ${ex.unitLabel}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // Hedef ağırlık/süre düzenleme penceresi
  void _editTargetDialog(AssignedExercise item) {
    final lastWeekCtrl = TextEditingController(
      text: item.lastWeekValue.toStringAsFixed(0),
    );
    final targetCtrl = TextEditingController(
      text: item.targetValue.toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              try {
                final double lw = double.parse(lastWeekCtrl.text.trim());
                final double tg = double.parse(targetCtrl.text.trim());
                setState(() {
                  item.lastWeekValue = lw;
                  item.targetValue = tg;
                });
                Navigator.pop(dialogContext);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lütfen geçerli bir sayı giriniz!'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dayExercises = AppStateData.assignedExercises
        .where((e) => e.day == _selectedDay)
        .toList();

    return Column(
      children: [
        // Yatay gün seçici
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

        // Üst aksiyon butonları
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/catalog');
                    setState(() {});
                  },
                  icon: const Icon(Icons.list, size: 18),
                  label: const Text('Tüm Hareketlerim'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _showAddFromCatalogDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Güne Hareket Ekle'),
                ),
              ),
            ],
          ),
        ),

        // Seçili günün hareket listesi
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
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
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
                        subtitle: Text(
                          '${item.exercise.region} • Hedef: ${item.targetValue.toStringAsFixed(0)} ${item.exercise.unitLabel}',
                          style: const TextStyle(fontSize: 12),
                        ),
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
                              onPressed: () {
                                setState(() {
                                  AppStateData.assignedExercises.removeWhere(
                                    (e) => e.id == item.id,
                                  );
                                });
                              },
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
