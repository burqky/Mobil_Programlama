class BodyMeasurement {
  String id;
  String dateLabel;
  double weight;
  double fatRatio = 16.0;
  double armCircumference = 37.0;
  double waistCircumference = 80.0;

  BodyMeasurement({
    required this.id,
    required this.dateLabel,
    required this.weight,
    required this.fatRatio,
    required this.armCircumference,
    required this.waistCircumference,
  });

  // İsimli Yapıcı - Sadece kilo ve tarih girildiğinde varsayılan değerlerle ölçüm oluşturur (2. Hafta PDF Syf 86-89)
  BodyMeasurement.standard({
    required this.id,
    required this.dateLabel,
    required this.weight,
  }) {
    fatRatio = 16.0;
    armCircumference = 37.0;
    waistCircumference = 80.0;
  }

  String get summaryInfo {
    return '$dateLabel — ${weight.toStringAsFixed(1)} kg (%${fatRatio.toStringAsFixed(1)} Yağ)';
  }

  set updateWeight(double newWeight) {
    if (newWeight > 0) {
      weight = newWeight;
    }
  }
}
