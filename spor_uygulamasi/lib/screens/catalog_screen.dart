import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../data/app_state_data.dart';
import '../models/catalog_exercise.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _selectedFilterRegion = 'Tümü';
  late TextEditingController _regionInputController;

  @override
  void initState() {
    super.initState();
    _regionInputController = TextEditingController();
  }

  @override
  void dispose() {
    _regionInputController.dispose();
    super.dispose();
  }

  void _addRegion() {
    final text = _regionInputController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen bir bölge adı yazın.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (AppStateData.targetRegions.contains(text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bu bölge zaten mevcut.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      AppStateData.targetRegions.add(text);
      _regionInputController.clear();
    });
  }

  void _deleteRegion(String region) {
    if (AppStateData.targetRegions.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('En az bir bölge kalmalıdır.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      AppStateData.targetRegions.remove(region);
      if (_selectedFilterRegion == region) {
        _selectedFilterRegion = 'Tümü';
      }
    });
  }

  void _showExerciseFormDialog({CatalogExercise? editingExercise}) {
    final bool isEditing = editingExercise != null;
    final nameController = TextEditingController(
      text: isEditing ? editingExercise.name : '',
    );
    final setsController = TextEditingController(
      text: isEditing ? editingExercise.sets : '3 Set x 10 Tekrar',
    );
    final targetController = TextEditingController(
      text: isEditing ? editingExercise.defaultTarget.toString() : '50',
    );
    final lastWeekController = TextEditingController(
      text: isEditing ? editingExercise.defaultLastWeek.toString() : '45',
    );

    String selectedRegion = isEditing &&
            AppStateData.targetRegions.contains(editingExercise.region)
        ? editingExercise.region
        : AppStateData.targetRegions.first;
    bool isCardio = isEditing ? editingExercise.isCardio : false;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                isEditing ? 'Hareketi Düzenle' : 'Yeni Hareket Ekle',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Hareket Adı',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Hedef Bölge',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: AppStateData.targetRegions.map((region) {
                        final isSelected = selectedRegion == region;
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              selectedRegion = region;
                              if (region == 'Kardiyo') {
                                isCardio = true;
                              }
                            });
                          },
                          child: Chip(
                            label: Text(
                              region,
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                            backgroundColor: isSelected
                                ? AppColors.primary
                                : AppColors.background,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: setsController,
                      decoration: const InputDecoration(
                        labelText: 'Set ve Tekrar (Örn: 3 Set x 12 Tekrar)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: targetController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Hedef Değer',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: lastWeekController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Geçen Hafta',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text(
                          'Tür: ',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: !isCardio
                                ? AppColors.primary
                                : Colors.transparent,
                          ),
                          onPressed: () {
                            setDialogState(() {
                              isCardio = false;
                            });
                          },
                          child: Text(
                            'Ağırlık (kg)',
                            style: TextStyle(
                              color: !isCardio
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: isCardio
                                ? AppColors.primary
                                : Colors.transparent,
                          ),
                          onPressed: () {
                            setDialogState(() {
                              isCardio = true;
                            });
                          },
                          child: Text(
                            'Kardiyo (dk)',
                            style: TextStyle(
                              color: isCardio
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('İptal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Hareket adı boş bırakılamaz.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    double targetVal = 0;
                    double lastWeekVal = 0;

                    try {
                      targetVal = double.parse(
                        targetController.text.trim().replaceAll(',', '.'),
                      );
                      lastWeekVal = double.parse(
                        lastWeekController.text.trim().replaceAll(',', '.'),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Lütfen sayısal alanları doğru girin.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    } finally {
                      debugPrint('Katalog form doğrulaması tamamlandı.');
                    }

                    setState(() {
                      final setsText = setsController.text.trim().isEmpty
                          ? '3 Set x 10 Tekrar'
                          : setsController.text.trim();

                      if (isEditing) {
                        editingExercise.name = name;
                        editingExercise.region = selectedRegion;
                        editingExercise.sets = setsText;
                        editingExercise.isCardio = isCardio;
                        editingExercise.updateDefaultTarget = targetVal;
                        editingExercise.defaultLastWeek = lastWeekVal;
                      } else {
                        final newEx = CatalogExercise(
                          id: 'cat_${DateTime.now().millisecondsSinceEpoch}',
                          name: name,
                          region: selectedRegion,
                          sets: setsText,
                          isCardio: isCardio,
                          defaultLastWeek: lastWeekVal,
                          defaultTarget: targetVal,
                        );
                        AppStateData.catalogExercises.add(newEx);
                      }
                    });
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Kaydet'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteCatalogExercise(CatalogExercise exercise) {
    setState(() {
      AppStateData.catalogExercises.removeWhere((e) => e.id == exercise.id);
      AppStateData.assignedExercises.removeWhere(
        (a) => a.exercise.id == exercise.id,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${exercise.name} katalogdan silindi.'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filterOptions = ['Tümü', ...AppStateData.targetRegions];
    final filteredCatalog = _selectedFilterRegion == 'Tümü'
        ? AppStateData.catalogExercises
        : AppStateData.catalogExercises
            .where((e) => e.region == _selectedFilterRegion)
            .toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Hareket Havuzu'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bölge ekleme alanı
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _regionInputController,
                      decoration: const InputDecoration(
                        labelText: 'Yeni Bölge Ekle (Örn: Karın)',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addRegion,
                    child: const Text('Ekle'),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Mevcut bölgeler (Wrap + Chip)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: AppStateData.targetRegions.map((region) {
                  return Chip(
                    label: Text(region, style: const TextStyle(fontSize: 12)),
                    onDeleted: () => _deleteRegion(region),
                    deleteIconColor: AppColors.textSecondary,
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // Yatay filtreleme çubuğu
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: filterOptions.map((region) {
                    final isSelected = _selectedFilterRegion == region;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: isSelected
                              ? AppColors.primary
                              : AppColors.surface,
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedFilterRegion = region;
                          });
                        },
                        child: Text(
                          region,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),

              // Egzersiz listesi
              Expanded(
                child: filteredCatalog.isEmpty
                    ? const Center(
                        child: Text(
                          'Bu bölgede kayıtlı hareket bulunmuyor.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredCatalog.length,
                        itemBuilder: (context, index) {
                          final item = filteredCatalog[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              subtitle: Text(
                                '${item.region} • ${item.sets}\nHedef: ${item.defaultTarget} ${item.unitLabel} | Geçen Hafta: ${item.defaultLastWeek} ${item.unitLabel}',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              isThreeLine: true,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      color: AppColors.primary,
                                    ),
                                    onPressed: () => _showExerciseFormDialog(
                                      editingExercise: item,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: AppColors.error,
                                    ),
                                    onPressed: () =>
                                        _deleteCatalogExercise(item),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showExerciseFormDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
