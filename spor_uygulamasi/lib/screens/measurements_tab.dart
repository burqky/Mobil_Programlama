import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../data/app_state_data.dart';
import '../models/body_measurement.dart';

class MeasurementsTab extends StatefulWidget {
  const MeasurementsTab({super.key});

  @override
  State<MeasurementsTab> createState() => _MeasurementsTabState();
}

class _MeasurementsTabState extends State<MeasurementsTab> {
  String _selectedMetric = 'Kilo';

  void _showAddMeasurementDialog() {
    final nextWeekNumber = AppStateData.bodyMeasurements.length + 1;
    final dateController = TextEditingController(text: '$nextWeekNumber. Hafta');
    final weightController = TextEditingController();
    final fatController = TextEditingController();
    final armController = TextEditingController();
    final waistController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Yeni Ölçüm Ekle',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                double weight = 0;
                double fat = 0;
                double arm = 0;
                double waist = 0;

                try {
                  weight = double.parse(
                    weightController.text.trim().replaceAll(',', '.'),
                  );
                  fat = double.parse(
                    fatController.text.trim().replaceAll(',', '.'),
                  );
                  arm = double.parse(
                    armController.text.trim().replaceAll(',', '.'),
                  );
                  waist = double.parse(
                    waistController.text.trim().replaceAll(',', '.'),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Lütfen tüm ölçüm alanlarına geçerli bir sayı girin.',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
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

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Yeni vücut ölçümü kaydedildi.'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  double _getMetricValue(BodyMeasurement m) {
    switch (_selectedMetric) {
      case 'Yağ Oranı':
        return m.fatRatio;
      case 'Kol':
        return m.armCircumference;
      case 'Bel':
        return m.waistCircumference;
      case 'Kilo':
      default:
        return m.weight;
    }
  }

  String _getMetricUnit() {
    if (_selectedMetric == 'Kilo') return 'kg';
    if (_selectedMetric == 'Yağ Oranı') return '%';
    return 'cm';
  }

  @override
  Widget build(BuildContext context) {
    final measurements = AppStateData.bodyMeasurements;
    final latest = measurements.isNotEmpty
        ? measurements.last
        : BodyMeasurement.standard(id: 'm_0', dateLabel: '-', weight: 75.0);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
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
                onPressed: _showAddMeasurementDialog,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Yeni Ölçüm'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 2 Sütunlu Özet Izgarası (GridView.count)
          SizedBox(
            height: 195,
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.9,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildMetricCard(
                  'Kilo',
                  '${latest.weight} kg',
                  Icons.monitor_weight_outlined,
                ),
                _buildMetricCard(
                  'Yağ Oranı',
                  '%${latest.fatRatio}',
                  Icons.percent_outlined,
                ),
                _buildMetricCard(
                  'Kol',
                  '${latest.armCircumference} cm',
                  Icons.fitness_center_outlined,
                ),
                _buildMetricCard(
                  'Bel',
                  '${latest.waistCircumference} cm',
                  Icons.straighten_outlined,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Native Sütun Grafiği (Container + Row + Column + Expanded flex)
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$_selectedMetric Değişim Grafiği (${_getMetricUnit()})',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Text(
                      'Kartlara dokunarak değiştirin',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 160,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: measurements.map((m) {
                      final val = _getMetricValue(m);
                      final maxVal = measurements
                          .map(_getMetricValue)
                          .reduce((a, b) => a > b ? a : b);
                      final int barFlex = maxVal > 0
                          ? ((val / maxVal) * 70).round().clamp(15, 75)
                          : 20;
                      final int emptyFlex = 100 - barFlex;

                      return Expanded(
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
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Ölçüm Geçmişi',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ...measurements.reversed.map(
            (m) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(
                  Icons.calendar_month_outlined,
                  color: AppColors.primary,
                ),
                title: Text(
                  m.summaryInfo,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                subtitle: Text(
                  'Kol: ${m.armCircumference} cm | Bel: ${m.waistCircumference} cm',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    final bool isSelected = _selectedMetric == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMetric = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
