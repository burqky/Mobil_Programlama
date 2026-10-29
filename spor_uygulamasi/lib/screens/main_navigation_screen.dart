import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../data/app_state_data.dart';
import 'daily_program_tab.dart';
import 'weekly_program_tab.dart';
import 'measurements_tab.dart';
import 'account_tab.dart';

class MainNavigationScreen extends StatefulWidget {
  final String? userName;
  final String? userEmail;

  const MainNavigationScreen({
    super.key,
    this.userName,
    this.userEmail,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // Açılışta ilk sekme (0: Günün Programı) seçili gelir
  int _currentIndex = 0;

  final List<String> _titles = const [
    'Günün Programı',
    'Haftalık Program',
    'Vücut Ölçümleri',
    'Hesabım',
  ];

  @override
  Widget build(BuildContext context) {
    final String name = widget.userName ?? AppStateData.currentUserName;
    final String email = widget.userEmail ?? AppStateData.currentUserEmail;

    final List<Widget> pages = [
      const DailyProgramTab(),
      const WeeklyProgramTab(),
      const MeasurementsTab(),
      AccountTab(userName: name, userEmail: email),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_titles[_currentIndex]),
        actions: [
          IconButton(
            tooltip: 'Hareket Havuzu',
            icon: const Icon(Icons.list_alt_outlined, color: AppColors.primary),
            onPressed: () async {
              await Navigator.pushNamed(context, '/catalog');
              setState(() {});
            },
          ),
        ],
      ),
      body: SafeArea(
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.today_outlined),
            activeIcon: Icon(Icons.today),
            label: 'Günlük',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Haftalık',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Ölçümler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Hesabım',
          ),
        ],
      ),
    );
  }
}
