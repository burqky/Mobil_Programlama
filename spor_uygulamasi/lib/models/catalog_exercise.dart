class CatalogExercise {
  String id;
  String name;
  String region;
  String sets;
  bool isCardio;
  double defaultLastWeek;
  double defaultTarget;

  CatalogExercise({
    required this.id,
    required this.name,
    required this.region,
    required this.sets,
    required this.isCardio,
    required this.defaultLastWeek,
    required this.defaultTarget,
  });

  // Kardiyo hareketleri için varsayılan değerlerle nesne oluşturur
  CatalogExercise.cardioDefault({
    required this.id,
    required this.name,
    this.defaultLastWeek = 20.0,
    this.defaultTarget = 30.0,
  })  : region = 'Kardiyo',
        sets = '1 Set (Süre)',
        isCardio = true;

  // Kardiyo ise dakika (dk), ağırlık ise kilogram (kg) döndürür
  String get unitLabel => isCardio ? 'dk' : 'kg';

  // Hedef değerin sıfırdan büyük olmasını kontrol eder
  set updateDefaultTarget(double value) {
    if (value > 0) {
      defaultTarget = value;
    }
  }
}
