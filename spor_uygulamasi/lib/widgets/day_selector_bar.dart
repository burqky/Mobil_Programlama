import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Günlük ve Haftalık program ekranlarında ortak kullanılan yatay gün seçici widget
/// 1. Hafta PDF (for-in, add) ve 6. Hafta PDF (ListView Axis.horizontal) yapıları kullanılmıştır
class DaySelectorBar extends StatelessWidget {
  final List<String> days;
  final String selectedDay;
  // 2. Hafta PDF Syf 24: Parametre olarak Function tipi kullanımı
  final Function onDaySelected;

  const DaySelectorBar({
    super.key,
    required this.days,
    required this.selectedDay,
    required this.onDaySelected,
  });

  // 1. Hafta PDF Syf 41 & 75: for-in döngüsü ve add() ile widget listesi oluşturma
  List<Widget> _gunButonlariniOlustur() {
    List<Widget> butonlar = [];
    for (String day in days) {
      final bool selected = day == selectedDay;
      butonlar.add(
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              onDaySelected(day);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                day,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  color: selected ? Colors.white : AppColors.textPrimary,
                ),
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
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: SizedBox(
        height: 38,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: _gunButonlariniOlustur(),
        ),
      ),
    );
  }
}
