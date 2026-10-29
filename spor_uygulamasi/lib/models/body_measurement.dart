class BodyMeasurement {
  String id;
  String dateLabel;
  double weight;
  double fatRatio;
  double armCircumference;
  double waistCircumference;

  BodyMeasurement({
    required this.id,
    required this.dateLabel,
    required this.weight,
    required this.fatRatio,
    required this.armCircumference,
    required this.waistCircumference,
  });

  // Sadece kilo ve tarih girildiğinde varsayılan değerlerle ölçüm oluşturur
  BodyMeasurement.standard({
    required this.id,
    required this.dateLabel,
    required this.weight,
  })  : fatRatio = 16.0,
        armCircumference = 37.0,
        waistCircumference = 80.0;

  String get summaryInfo =>
      '$dateLabel — ${weight.toStringAsFixed(1)} kg (%${fatRatio.toStringAsFixed(1)} Yağ)';

  set updateWeight(double newWeight) {
    if (newWeight > 0) {
      weight = newWeight;
    }
  }
}
