// Temel egzersiz üst sınıfı (2. Hafta PDF Syf 79-85 - Kalıtım / Inheritance)
class BaseExerciseItem {
  String id;
  String name;

  BaseExerciseItem({required this.id, required this.name});

  String bilgiYazdir() {
    return '$name ($id)';
  }
}

class CatalogExercise extends BaseExerciseItem {
  String region = '';
  String sets = '';
  bool isCardio = false;
  double defaultLastWeek = 0.0;
  double defaultTarget = 0.0;

  // İsimli parametreli yapıcı (2. Hafta PDF Syf 76)
  CatalogExercise({
    required super.id,
    required super.name,
    required this.region,
    required this.sets,
    required this.isCardio,
    required this.defaultLastWeek,
    required this.defaultTarget,
  });

  // İsimli Yapıcı - Named Constructor (2. Hafta PDF Syf 86-89)
  CatalogExercise.cardioDefault({
    required super.id,
    required super.name,
    this.defaultLastWeek = 20.0,
    this.defaultTarget = 30.0,
  }) {
    region = 'Kardiyo';
    sets = '1 Set (Süre)';
    isCardio = true;
  }

  // Factory Yapıcı - Yönlendirici Yapıcı (2. Hafta PDF Syf 90-95)
  factory CatalogExercise.varsayilanAgirlik({
    required String id,
    required String name,
    required String region,
  }) {
    return CatalogExercise(
      id: id,
      name: name,
      region: region,
      sets: '3 Set x 10 Tekrar',
      isCardio: false,
      defaultLastWeek: 40.0,
      defaultTarget: 45.0,
    );
  }

  // Metot Ezme (Overriding) ve super kullanımı (2. Hafta PDF Syf 81-85)
  @override
  String bilgiYazdir() {
    return '${super.bilgiYazdir()} - $region ($sets)';
  }

  // Getter: Kardiyo ise dakika (dk), ağırlık ise kilogram (kg) döndürür (2. Hafta PDF Syf 47-49)
  String get unitLabel {
    return isCardio ? 'dk' : 'kg';
  }

  // Setter: Hedef değerin sıfırdan büyük olmasını kontrol eder (2. Hafta PDF Syf 47-49)
  set updateDefaultTarget(double value) {
    if (value > 0) {
      defaultTarget = value;
    }
  }
}
