import 'catalog_exercise.dart';

class AssignedExercise {
  String id;
  // Composition: Başka bir sınıfın nesnesini barındırır (2. Hafta PDF Syf 96-98)
  CatalogExercise exercise;
  String day;
  double lastWeekValue = 0.0;
  double targetValue = 0.0;
  // Null-Safety: Tamamlanmadan önce null tutulur (2. Hafta PDF Syf 52-65)
  double? currentValue;
  bool isCompleted = false;

  AssignedExercise({
    required this.id,
    required this.exercise,
    required this.day,
    required this.lastWeekValue,
    required this.targetValue,
    this.currentValue,
    this.isCompleted = false,
  });

  // İsimli Yapıcı - Katalogdaki bir hareketi seçilen güne varsayılan değerleriyle atar (2. Hafta PDF Syf 86-89)
  AssignedExercise.fromCatalog({
    required this.id,
    required this.exercise,
    required this.day,
  }) {
    lastWeekValue = exercise.defaultLastWeek;
    targetValue = exercise.defaultTarget;
    currentValue = null;
    isCompleted = false;
  }

  // Girilen değer hedefin veya geçen haftanın altındaysa uyarı verir (2. Hafta PDF Null-Safety kontrolü)
  bool get hasPerformanceWarning {
    if (currentValue != null) {
      return currentValue! < targetValue || currentValue! < lastWeekValue;
    } else {
      return false;
    }
  }

  set completedWithValue(double value) {
    currentValue = value;
    isCompleted = true;
  }
}
