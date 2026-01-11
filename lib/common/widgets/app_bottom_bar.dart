import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/pages/inventory_page.dart';
import 'package:budidaya_lele_mobile/features/report/presentation/pages/report_page.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/pages/schedule_page.dart';
import 'package:budidaya_lele_mobile/features/user/presentation/pages/setting_page.dart';
import 'package:flutter/material.dart';

class AppBottomBar extends StatefulWidget {
  const AppBottomBar({super.key});

  @override
  State<AppBottomBar> createState() => _AppBottomBarState();
}

class _AppBottomBarState extends State<AppBottomBar> {
  int _selectedIndex = 0;

  static const List<Widget> pages = <Widget>[
    DashboardPage(),
    ReportPage(),
    InventoryPage(),
    SchedulePage(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: pages.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          height: 1.5,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 12,
          height: 1.5,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.space_dashboard_outlined, size: 34),
            activeIcon: Icon(Icons.space_dashboard_rounded, size: 34),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined, size: 34),
            activeIcon: Icon(Icons.analytics_rounded, size: 34),
            label: "Laporan",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined, size: 34),
            activeIcon: Icon(Icons.inventory_2_rounded, size: 34),
            label: "Inventaris",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_outlined, size: 34),
            activeIcon: Icon(Icons.event_note_rounded, size: 34),
            label: "Jadwal",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined, size: 34),
            activeIcon: Icon(Icons.settings, size: 34),
            label: "Pengaturan",
          ),
        ],
        selectedItemColor: AppColors.secondary,
        unselectedItemColor: AppColors.secondary.withAlpha(250),
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
