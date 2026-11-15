import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../data/app_state_data.dart';
import '../models/body_measurement.dart';
import '../widgets/measurement_metric_card.dart';

class MeasurementsTab extends StatefulWidget {
  const MeasurementsTab({super.key});

  @override
  State<MeasurementsTab> createState() => _MeasurementsTabState();
}

class _MeasurementsTabState extends State<MeasurementsTab> {
  String _selectedMetric = 'Kilo';
  // Tıklanarak detayları açılan ölçüm kayıtlarının ID listesi (1. Hafta PDF: List, indexOf, add, removeAt)
  final List<String> _expandedMeasurementIds = [];

  void _showAddMeasurementDialog() {
    final nextWeekNumber = AppStateData.bodyMeasurements.length + 1;
    final dateController = TextEditingController(
      text: '$nextWeekNumber. Hafta',
    );
    final weightController = TextEditingController();
    final fatController = TextEditingController();
    final armController = TextEditingController();
    final waistController = TextEditingController();

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
            double weight = 0;
            double fat = 0;
            double arm = 0;
            double waist = 0;

            // 1. Hafta PDF Syf 95 & 2. Hafta PDF Syf 50-51: try - on FormatException catch - finally
            try {
              weight = double.parse(weightController.text.trim());
              fat = double.parse(fatController.text.trim());
              arm = double.parse(armController.text.trim());
              waist = double.parse(waistController.text.trim());
            } on FormatException catch (e) {
              debugPrint('Ölçüm sayısal dönüşüm hatası: $e');
              final hataSnackBar = SnackBar(
                duration: const Duration(seconds: 3),
                content: const Text(
                  'Lütfen tüm ölçüm alanlarına geçerli bir sayı girin.',
                ),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  textColor: Colors.white,
                  label: 'TAMAM',
                  onPressed: () {},
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(hataSnackBar);
              return;
            } catch (e) {
              debugPrint('Beklenmeyen hata: $e');
              return;
            } finally {
              debugPrint('Ölçüm doğrulama işlemi tamamlandı.');
            }

            setState(() {
              AppStateData.bodyMeasurements.add(
                BodyMeasurement(
                  id: 'm_${DateTime.now().millisecondsSinceEpoch}',
                  dateLabel: dateController.text.trim().isEmpty
                      ? '$nextWeekNumber. Hafta'
                      : dateController.text.trim(),
                  weight: weight,
                  fatRatio: fat,
                  armCircumference: arm,
                  waistCircumference: waist,
                ),
              );
            });
            Navigator.pop(dialogContext);

            final snackBar = SnackBar(
              duration: const Duration(seconds: 3),
              content: const Text('Yeni vücut ölçümü kaydedildi.'),
              backgroundColor: AppColors.success,
              action: SnackBarAction(
                textColor: Colors.white,
                label: 'TAMAM',
                onPressed: () {},
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: const Text('Kaydet'),
        );

        // 5. Hafta PDF Syf 19 & 6. Hafta PDF Syf 2: AlertDialog içinde ListView
        AlertDialog alert = AlertDialog(
          title: const Text(
            'Yeni Ölçüm Ekle',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 300,
            height: 310,
            child: ListView(
              children: [
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'Dönem / Tarih',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: weightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Kilo (kg)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: fatController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Yağ Oranı (%)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: armController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Kol Çevresi (cm)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: waistController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Bel Çevresi (cm)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [iptalButonu, kaydetButonu],
        );

        return alert;
      },
    );
  }

  // 1. Hafta PDF Syf 64-65: switch-case yerine if - else if - else yapısı
  double _getMetricValue(BodyMeasurement m) {
    if (_selectedMetric == 'Yağ Oranı') {
      return m.fatRatio;
    } else if (_selectedMetric == 'Kol') {
      return m.armCircumference;
    } else if (_selectedMetric == 'Bel') {
      return m.waistCircumference;
    } else {
      return m.weight;
    }
  }

  String _getMetricUnit() {
    if (_selectedMetric == 'Kilo') return 'kg';
    if (_selectedMetric == 'Yağ Oranı') return '%';
    return 'cm';
  }

  // 1. Hafta PDF (for-in, if-else) & 3. Hafta PDF (Expanded flex, Container, BoxDecoration) ile sütun grafik oluşturma
  List<Widget> _grafikSutunlariniOlustur(List<BodyMeasurement> measurements) {
    double maxVal = 0;
    for (BodyMeasurement item in measurements) {
      final double current = _getMetricValue(item);
      if (current > maxVal) {
        maxVal = current;
      }
    }

    List<Widget> sutunlar = [];
    for (BodyMeasurement m in measurements) {
      final double val = _getMetricValue(m);
      int barFlex = 20;
      if (maxVal > 0) {
        barFlex = ((val / maxVal) * 70).round();
        if (barFlex < 15) {
          barFlex = 15;
        } else if (barFlex > 75) {
          barFlex = 75;
        }
      }
      final int emptyFlex = 100 - barFlex;

      sutunlar.add(
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  flex: emptyFlex,
                  child: const SizedBox(),
                ),
                Text(
                  val.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  flex: barFlex,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  m.dateLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return sutunlar;
  }

  @override
  Widget build(BuildContext context) {
    final measurements = AppStateData.bodyMeasurements;
    final latest = measurements.isNotEmpty
        ? measurements.last
        : BodyMeasurement.standard(id: 'm_0', dateLabel: '-', weight: 75.0);

    // 1. Hafta PDF: Spread (...) yerine for-in ve add() ile liste elemanlarını oluşturma
    List<Widget> sayfaElemanlari = [];

    sayfaElemanlari.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Güncel Ölçümlerim',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: _showAddMeasurementDialog,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Yeni Ölçüm'),
          ),
        ],
      ),
    );
    sayfaElemanlari.add(const SizedBox(height: 12));

    // 6. Hafta PDF Syf 14-21: GridView.count (crossAxisCount: 2)
    sayfaElemanlari.add(
      SizedBox(
        height: 195,
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.9,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            MeasurementMetricCard(
              title: 'Kilo',
              value: '${latest.weight} kg',
              icon: Icons.monitor_weight_outlined,
              isSelected: _selectedMetric == 'Kilo',
              onTap: () => setState(() => _selectedMetric = 'Kilo'),
            ),
            MeasurementMetricCard(
              title: 'Yağ Oranı',
              value: '%${latest.fatRatio}',
              icon: Icons.percent_outlined,
              isSelected: _selectedMetric == 'Yağ Oranı',
              onTap: () => setState(() => _selectedMetric = 'Yağ Oranı'),
            ),
            MeasurementMetricCard(
              title: 'Kol',
              value: '${latest.armCircumference} cm',
              icon: Icons.fitness_center_outlined,
              isSelected: _selectedMetric == 'Kol',
              onTap: () => setState(() => _selectedMetric = 'Kol'),
            ),
            MeasurementMetricCard(
              title: 'Bel',
              value: '${latest.waistCircumference} cm',
              icon: Icons.straighten_outlined,
              isSelected: _selectedMetric == 'Bel',
              onTap: () => setState(() => _selectedMetric = 'Bel'),
            ),
          ],
        ),
      ),
    );
    sayfaElemanlari.add(const SizedBox(height: 16));

    // Native Sütun Grafiği (Container + Row + Column + Expanded flex)
    sayfaElemanlari.add(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$_selectedMetric Değişim Grafiği (${_getMetricUnit()})',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _grafikSutunlariniOlustur(measurements),
              ),
            ),
          ],
        ),
      ),
    );
    sayfaElemanlari.add(const SizedBox(height: 16));

    sayfaElemanlari.add(
      const Text(
        'Ölçüm Geçmişi',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
    sayfaElemanlari.add(const SizedBox(height: 8));

    // 1. Hafta PDF Syf 41-42: measurements.reversed ile ters sırada listeleme
    for (BodyMeasurement m in measurements.reversed) {
      final int expandedIdx = _expandedMeasurementIds.indexOf(m.id);
      final bool isExpanded = expandedIdx != -1;

      sayfaElemanlari.add(
        Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedMeasurementIds.removeAt(expandedIdx);
                } else {
                  _expandedMeasurementIds.add(m.id);
                }
              });
            },
            leading: const Icon(
              Icons.calendar_month_outlined,
              color: AppColors.primary,
            ),
            title: Text(
              m.dateLabel,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: isExpanded
                ? Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Kilo: ${m.weight} kg  •  Yağ: %${m.fatRatio}\nKol: ${m.armCircumference} cm  |  Bel: ${m.waistCircumference} cm',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  )
                : null,
            isThreeLine: isExpanded,
            trailing: Icon(
              isExpanded
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: sayfaElemanlari,
      ),
    );
  }
}
