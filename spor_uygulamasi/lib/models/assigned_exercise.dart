import 'catalog_exercise.dart';

class AssignedExercise {
  String id;
  CatalogExercise exercise;
  String day;
  double lastWeekValue;
  double targetValue;
  double? currentValue;
  bool isCompleted;

  AssignedExercise({
    required this.id,
    required this.exercise,
    required this.day,
    required this.lastWeekValue,
    required this.targetValue,
    this.currentValue,
    this.isCompleted = false,
  });

  // Katalogdaki bir hareketi seçilen güne varsayılan değerleriyle atar
  AssignedExercise.fromCatalog({
    required this.id,
    required this.exercise,
    required this.day,
  })  : lastWeekValue = exercise.defaultLastWeek,
        targetValue = exercise.defaultTarget,
        currentValue = null,
        isCompleted = false;

  // Girilen değer hedefin veya geçen haftanın altındaysa uyarı verir
  bool get hasPerformanceWarning {
    if (currentValue == null) return false;
    return currentValue! < targetValue || currentValue! < lastWeekValue;
  }

  set completedWithValue(double value) {
    currentValue = value;
    isCompleted = true;
  }
}
