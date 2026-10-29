import '../models/catalog_exercise.dart';
import '../models/assigned_exercise.dart';
import '../models/body_measurement.dart';

// Uygulama genelinde kullanılan başlangıç verileri
class AppStateData {
  static String currentUserName = 'Ahmet Yılmaz';
  static String currentUserEmail = 'ahmet@isparta.edu.tr';
  static String currentStudentNo = '2211012045';

  static const List<String> weekDays = [
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar',
  ];

  static final Map<String, String> dayFocusMap = {
    'Pazartesi': 'Göğüs & Ön Kol Antrenmanı',
    'Salı': 'Sırt & Arka Kol Antrenmanı',
    'Çarşamba': 'Bacak & Kardiyo Günü',
    'Perşembe': 'Omuz & Kardiyo Günü',
    'Cuma': 'Tam Vücut Antrenmanı',
    'Cumartesi': 'Aktif Dinlenme & Kardiyo',
    'Pazar': 'Dinlenme Günü',
  };

  static final List<String> targetRegions = [
    'Göğüs',
    'Sırt',
    'Bacak',
    'Omuz',
    'Kol',
    'Kardiyo',
  ];

  static final List<CatalogExercise> catalogExercises = [
    CatalogExercise(
      id: 'cat_1',
      name: 'Bench Press',
      region: 'Göğüs',
      sets: '4 Set x 10 Tekrar',
      isCardio: false,
      defaultLastWeek: 70.0,
      defaultTarget: 75.0,
    ),
    CatalogExercise(
      id: 'cat_2',
      name: 'Incline Dumbbell Press',
      region: 'Göğüs',
      sets: '3 Set x 12 Tekrar',
      isCardio: false,
      defaultLastWeek: 24.0,
      defaultTarget: 26.0,
    ),
    CatalogExercise(
      id: 'cat_3',
      name: 'Lat Pulldown',
      region: 'Sırt',
      sets: '4 Set x 12 Tekrar',
      isCardio: false,
      defaultLastWeek: 55.0,
      defaultTarget: 60.0,
    ),
    CatalogExercise(
      id: 'cat_4',
      name: 'Barbell Row',
      region: 'Sırt',
      sets: '3 Set x 10 Tekrar',
      isCardio: false,
      defaultLastWeek: 50.0,
      defaultTarget: 55.0,
    ),
    CatalogExercise(
      id: 'cat_5',
      name: 'Squat',
      region: 'Bacak',
      sets: '4 Set x 8 Tekrar',
      isCardio: false,
      defaultLastWeek: 90.0,
      defaultTarget: 95.0,
    ),
    CatalogExercise(
      id: 'cat_6',
      name: 'Leg Press',
      region: 'Bacak',
      sets: '4 Set x 12 Tekrar',
      isCardio: false,
      defaultLastWeek: 140.0,
      defaultTarget: 150.0,
    ),
    CatalogExercise(
      id: 'cat_7',
      name: 'Overhead Shoulder Press',
      region: 'Omuz',
      sets: '4 Set x 10 Tekrar',
      isCardio: false,
      defaultLastWeek: 40.0,
      defaultTarget: 42.5,
    ),
    CatalogExercise(
      id: 'cat_8',
      name: 'Lateral Raise',
      region: 'Omuz',
      sets: '3 Set x 15 Tekrar',
      isCardio: false,
      defaultLastWeek: 10.0,
      defaultTarget: 12.5,
    ),
    CatalogExercise(
      id: 'cat_9',
      name: 'Barbell Bicep Curl',
      region: 'Kol',
      sets: '3 Set x 12 Tekrar',
      isCardio: false,
      defaultLastWeek: 25.0,
      defaultTarget: 27.5,
    ),
    CatalogExercise(
      id: 'cat_10',
      name: 'Tricep Rope Pushdown',
      region: 'Kol',
      sets: '3 Set x 12 Tekrar',
      isCardio: false,
      defaultLastWeek: 30.0,
      defaultTarget: 35.0,
    ),
    CatalogExercise.cardioDefault(
      id: 'cat_11',
      name: 'Koşu Bandı',
      defaultLastWeek: 25.0,
      defaultTarget: 30.0,
    ),
    CatalogExercise.cardioDefault(
      id: 'cat_12',
      name: 'Kondisyon Bisikleti',
      defaultLastWeek: 20.0,
      defaultTarget: 25.0,
    ),
  ];

  static final List<AssignedExercise> assignedExercises = [
    AssignedExercise(
      id: 'asg_1',
      exercise: catalogExercises[0],
      day: 'Pazartesi',
      lastWeekValue: 70.0,
      targetValue: 75.0,
      currentValue: null,
      isCompleted: false,
    ),
    AssignedExercise(
      id: 'asg_2',
      exercise: catalogExercises[1],
      day: 'Pazartesi',
      lastWeekValue: 24.0,
      targetValue: 26.0,
      currentValue: null,
      isCompleted: false,
    ),
    AssignedExercise(
      id: 'asg_3',
      exercise: catalogExercises[8],
      day: 'Pazartesi',
      lastWeekValue: 25.0,
      targetValue: 27.5,
      currentValue: 27.5,
      isCompleted: true,
    ),
    AssignedExercise(
      id: 'asg_4',
      exercise: catalogExercises[2],
      day: 'Salı',
      lastWeekValue: 55.0,
      targetValue: 60.0,
    ),
    AssignedExercise(
      id: 'asg_5',
      exercise: catalogExercises[3],
      day: 'Salı',
      lastWeekValue: 50.0,
      targetValue: 55.0,
    ),
    AssignedExercise(
      id: 'asg_6',
      exercise: catalogExercises[9],
      day: 'Salı',
      lastWeekValue: 30.0,
      targetValue: 35.0,
    ),
    AssignedExercise(
      id: 'asg_7',
      exercise: catalogExercises[4],
      day: 'Çarşamba',
      lastWeekValue: 90.0,
      targetValue: 95.0,
    ),
    AssignedExercise(
      id: 'asg_8',
      exercise: catalogExercises[5],
      day: 'Çarşamba',
      lastWeekValue: 140.0,
      targetValue: 150.0,
    ),
    AssignedExercise(
      id: 'asg_9',
      exercise: catalogExercises[10],
      day: 'Çarşamba',
      lastWeekValue: 25.0,
      targetValue: 30.0,
    ),
    AssignedExercise(
      id: 'asg_10',
      exercise: catalogExercises[6],
      day: 'Perşembe',
      lastWeekValue: 40.0,
      targetValue: 42.5,
    ),
    AssignedExercise(
      id: 'asg_11',
      exercise: catalogExercises[7],
      day: 'Perşembe',
      lastWeekValue: 10.0,
      targetValue: 12.5,
    ),
    AssignedExercise(
      id: 'asg_12',
      exercise: catalogExercises[0],
      day: 'Cuma',
      lastWeekValue: 70.0,
      targetValue: 75.0,
    ),
    AssignedExercise(
      id: 'asg_13',
      exercise: catalogExercises[2],
      day: 'Cuma',
      lastWeekValue: 55.0,
      targetValue: 60.0,
    ),
    AssignedExercise(
      id: 'asg_14',
      exercise: catalogExercises[11],
      day: 'Cumartesi',
      lastWeekValue: 20.0,
      targetValue: 25.0,
    ),
  ];

  static final List<BodyMeasurement> bodyMeasurements = [
    BodyMeasurement(
      id: 'm_1',
      dateLabel: '1. Hafta',
      weight: 82.5,
      fatRatio: 18.5,
      armCircumference: 36.0,
      waistCircumference: 86.0,
    ),
    BodyMeasurement(
      id: 'm_2',
      dateLabel: '2. Hafta',
      weight: 81.2,
      fatRatio: 17.8,
      armCircumference: 36.5,
      waistCircumference: 84.5,
    ),
    BodyMeasurement(
      id: 'm_3',
      dateLabel: '3. Hafta',
      weight: 80.0,
      fatRatio: 16.9,
      armCircumference: 37.2,
      waistCircumference: 83.0,
    ),
    BodyMeasurement(
      id: 'm_4',
      dateLabel: '4. Hafta',
      weight: 78.8,
      fatRatio: 15.8,
      armCircumference: 38.0,
      waistCircumference: 81.5,
    ),
  ];
}
