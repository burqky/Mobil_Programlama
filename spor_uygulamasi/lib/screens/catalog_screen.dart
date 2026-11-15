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
  bool _showRegionManager = false;
  // 1. Hafta PDF: List, indexOf, add, removeAt kullanımı
  final List<String> _expandedCatalogIds = [];
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

  // 1. Hafta PDF Syf 75: for-in döngüsü ile listede eleman kontrolü
  bool _listedeVarMi(List<String> liste, String aranan) {
    for (String eleman in liste) {
      if (eleman == aranan) {
        return true;
      }
    }
    return false;
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

    if (_listedeVarMi(AppStateData.targetRegions, text)) {
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
      final int idx = AppStateData.targetRegions.indexOf(region);
      if (idx != -1) {
        AppStateData.targetRegions.removeAt(idx);
      }
      if (_selectedFilterRegion == region) {
        _selectedFilterRegion = 'Tümü';
      }
    });
  }

  // 4. Hafta PDF Syf 24: StatefulBuilder yerine ayrı StatefulWidget (HareketFormDialog) ile diyalog açma
  void _showExerciseFormDialog({CatalogExercise? editingExercise}) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return HareketFormDialog(
          editingExercise: editingExercise,
          onSaved: () {
            setState(() {});
          },
        );
      },
    );
  }

  // 1. Hafta PDF Syf 40-42 & 72-76: indexOf, removeAt ve for döngüsü ile silme
  void _deleteCatalogExercise(CatalogExercise exercise) {
    setState(() {
      final int catIndex = AppStateData.catalogExercises.indexOf(exercise);
      if (catIndex != -1) {
        AppStateData.catalogExercises.removeAt(catIndex);
      }

      for (int i = AppStateData.assignedExercises.length - 1; i >= 0; i--) {
        if (AppStateData.assignedExercises[i].exercise.id == exercise.id) {
          AppStateData.assignedExercises.removeAt(i);
        }
      }
    });

    final snackBar = SnackBar(
      duration: const Duration(seconds: 3),
      content: Text('${exercise.name} katalogdan silindi.'),
      backgroundColor: AppColors.primary,
      action: SnackBarAction(
        textColor: Colors.white,
        label: 'TAMAM',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // 3. Hafta PDF Syf 18-19 (Wrap) & Syf 21-26 (BoxDecoration): Chip yerine Container + InkWell bölge etiketleri
  List<Widget> _bolgeEtiketleriniOlustur() {
    List<Widget> etiketler = [];
    for (String region in AppStateData.targetRegions) {
      etiketler.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                region,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 6),
              InkWell(
                onTap: () => _deleteRegion(region),
                child: const Icon(
                  Icons.close,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return etiketler;
  }

  // Yatay filtreleme butonlarını for döngüsü ile oluşturma
  List<Widget> _filtreButonlariniOlustur(List<String> filterOptions) {
    List<Widget> butonlar = [];
    for (String region in filterOptions) {
      final bool isSelected = _selectedFilterRegion == region;
      butonlar.add(
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor:
                  isSelected ? AppColors.primary : AppColors.surface,
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
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
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontSize: 13,
              ),
            ),
          ),
        ),
      );
    }
    return butonlar;
  }

  @override
  Widget build(BuildContext context) {
    // 1. Hafta PDF: Spread (...) operatörü yerine for-in döngüsü ve add() kullanımı
    List<String> filterOptions = ['Tümü'];
    for (String bolge in AppStateData.targetRegions) {
      filterOptions.add(bolge);
    }

    List<CatalogExercise> filteredCatalog = [];
    for (CatalogExercise ex in AppStateData.catalogExercises) {
      if (_selectedFilterRegion == 'Tümü' ||
          ex.region == _selectedFilterRegion) {
        filteredCatalog.add(ex);
      }
    }

    // 1. Hafta PDF: Bölge yöneticisi açıksa gösterilecek widget listesi
    List<Widget> bolgeYonetimAlanlari = [];
    if (_showRegionManager) {
      bolgeYonetimAlanlari.add(
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
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: _addRegion,
              child: const Text('Ekle'),
            ),
          ],
        ),
      );
      bolgeYonetimAlanlari.add(const SizedBox(height: 10));
      bolgeYonetimAlanlari.add(
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: _bolgeEtiketleriniOlustur(),
        ),
      );
      bolgeYonetimAlanlari.add(const SizedBox(height: 12));
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Hareket Havuzu'),
        actions: [
          TextButton.icon(
            onPressed: () {
              setState(() {
                _showRegionManager = !_showRegionManager;
              });
            },
            icon: Icon(
              _showRegionManager ? Icons.expand_less : Icons.category_outlined,
              size: 18,
            ),
            label: const Text('Bölgeler'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: bolgeYonetimAlanlari,
              ),

              // Yatay filtreleme çubuğu (6. Hafta PDF: ListView Axis.horizontal)
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _filtreButonlariniOlustur(filterOptions),
                ),
              ),
              const SizedBox(height: 12),

              // Egzersiz listesi (6. Hafta PDF Syf 7-13: ListView.builder)
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
                          final int expandedIdx = _expandedCatalogIds.indexOf(
                            item.id,
                          );
                          final bool isExpanded = expandedIdx != -1;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  if (isExpanded) {
                                    _expandedCatalogIds.removeAt(expandedIdx);
                                  } else {
                                    _expandedCatalogIds.add(item.id);
                                  }
                                });
                              },
                              title: Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              subtitle: isExpanded
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        '${item.region} • ${item.sets}\nHedef: ${item.defaultTarget.toStringAsFixed(0)} ${item.unitLabel}  |  Geçen Hafta: ${item.defaultLastWeek.toStringAsFixed(0)} ${item.unitLabel}',
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  : null,
                              isThreeLine: isExpanded,
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
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () => _showExerciseFormDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// 4. Hafta PDF Syf 24: Hareket ekleme ve düzenleme formu için bağımsız StatefulWidget
class HareketFormDialog extends StatefulWidget {
  final CatalogExercise? editingExercise;
  // 2. Hafta PDF Syf 24: Parametre olarak Function tipi
  final Function onSaved;

  const HareketFormDialog({
    super.key,
    this.editingExercise,
    required this.onSaved,
  });

  @override
  State<HareketFormDialog> createState() => _HareketFormDialogState();
}

class _HareketFormDialogState extends State<HareketFormDialog> {
  late TextEditingController _nameController;
  late TextEditingController _setsController;
  late TextEditingController _targetController;
  late TextEditingController _lastWeekController;
  String _selectedRegion = '';
  bool _isCardio = false;

  @override
  void initState() {
    super.initState();
    final editingExercise = widget.editingExercise;
    final bool isEditing = editingExercise != null;

    _nameController = TextEditingController(
      text: isEditing ? editingExercise.name : '',
    );
    _setsController = TextEditingController(
      text: isEditing ? editingExercise.sets : '3 Set x 10 Tekrar',
    );
    _targetController = TextEditingController(
      text: isEditing ? editingExercise.defaultTarget.toString() : '50',
    );
    _lastWeekController = TextEditingController(
      text: isEditing ? editingExercise.defaultLastWeek.toString() : '45',
    );

    bool bolgeMevcut = false;
    if (isEditing) {
      for (String bolge in AppStateData.targetRegions) {
        if (bolge == editingExercise.region) {
          bolgeMevcut = true;
        }
      }
    }

    if (isEditing && bolgeMevcut) {
      _selectedRegion = editingExercise.region;
    } else {
      _selectedRegion = AppStateData.targetRegions.first;
    }
    _isCardio = isEditing ? editingExercise.isCardio : false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _setsController.dispose();
    _targetController.dispose();
    _lastWeekController.dispose();
    super.dispose();
  }

  // 3. Hafta PDF (Wrap, BoxDecoration) & 5. Hafta PDF (GestureDetector): Hedef bölge seçenekleri
  List<Widget> _dialogBolgeSecenekleri() {
    List<Widget> secenekler = [];
    for (String region in AppStateData.targetRegions) {
      final bool isSelected = _selectedRegion == region;
      secenekler.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedRegion = region;
              if (region == 'Kardiyo') {
                _isCardio = true;
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            ),
            child: Text(
              region,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      );
    }
    return secenekler;
  }

  void _kaydet() {
    final name = _nameController.text.trim();
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

    // 1. Hafta PDF Syf 95 & 2. Hafta PDF Syf 50-51: try - on FormatException catch - finally
    try {
      targetVal = double.parse(_targetController.text.trim());
      lastWeekVal = double.parse(_lastWeekController.text.trim());
    } on FormatException catch (e) {
      debugPrint('Sayısal dönüşüm hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen sayısal alanları doğru girin.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    } catch (e) {
      debugPrint('Beklenmeyen hata: $e');
      return;
    } finally {
      debugPrint('Katalog form doğrulaması tamamlandı.');
    }

    final setsText = _setsController.text.trim().isEmpty
        ? '3 Set x 10 Tekrar'
        : _setsController.text.trim();

    final editingExercise = widget.editingExercise;
    if (editingExercise != null) {
      editingExercise.name = name;
      editingExercise.region = _selectedRegion;
      editingExercise.sets = setsText;
      editingExercise.isCardio = _isCardio;
      editingExercise.updateDefaultTarget = targetVal;
      editingExercise.defaultLastWeek = lastWeekVal;
    } else {
      final newEx = CatalogExercise(
        id: 'cat_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        region: _selectedRegion,
        sets: setsText,
        isCardio: _isCardio,
        defaultLastWeek: lastWeekVal,
        defaultTarget: targetVal,
      );
      AppStateData.catalogExercises.add(newEx);
    }

    widget.onSaved();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.editingExercise != null;

    Widget iptalButonu = TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('İptal'),
    );

    Widget kaydetButonu = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      onPressed: _kaydet,
      child: const Text('Kaydet'),
    );

    return AlertDialog(
      title: Text(
        isEditing ? 'Hareketi Düzenle' : 'Yeni Hareket Ekle',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: 320,
        height: 360,
        // 6. Hafta PDF Syf 2: ListView ile kaydırılabilir form alanı
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
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
              children: _dialogBolgeSecenekleri(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _setsController,
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
                    controller: _targetController,
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
                    controller: _lastWeekController,
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
            // 3. Hafta PDF Syf 18-19: Taşmayı önlemek için Row yerine Wrap kullanımı
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text(
                  'Tür: ',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        !_isCardio ? AppColors.primary : Colors.transparent,
                  ),
                  onPressed: () {
                    setState(() {
                      _isCardio = false;
                    });
                  },
                  child: Text(
                    'Ağırlık (kg)',
                    style: TextStyle(
                      color: !_isCardio ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        _isCardio ? AppColors.primary : Colors.transparent,
                  ),
                  onPressed: () {
                    setState(() {
                      _isCardio = true;
                    });
                  },
                  child: Text(
                    'Kardiyo (dk)',
                    style: TextStyle(
                      color: _isCardio ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [iptalButonu, kaydetButonu],
    );
  }
}
