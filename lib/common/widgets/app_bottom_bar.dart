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
        items: List.generate(5, (index) {
          final items = const [
            (
              icon: Icons.space_dashboard_outlined,
              activeIcon: Icons.space_dashboard_rounded,
              label: "Beranda",
            ),
            (
              icon: Icons.analytics_outlined,
              activeIcon: Icons.analytics_rounded,
              label: "Laporan",
            ),
            (
              icon: Icons.inventory_2_outlined,
              activeIcon: Icons.inventory_2_rounded,
              label: "Inventaris",
            ),
            (
              icon: Icons.event_note_outlined,
              activeIcon: Icons.event_note_rounded,
              label: "Jadwal",
            ),
            (
              icon: Icons.settings_outlined,
              activeIcon: Icons.settings,
              label: "Pengaturan",
            ),
          ];

          return BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                border: _selectedIndex == index
                    ? Border(top: BorderSide(color: AppColors.secondary))
                    : Border(top: BorderSide(color: Colors.transparent)),
              ),
              padding: const EdgeInsets.only(top: 8),
              child: Icon(items[index].icon, size: 34),
            ),
            activeIcon: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.secondary, width: 2),
                ),
              ),
              padding: const EdgeInsets.only(top: 8),
              child: Icon(items[index].activeIcon, size: 34),
            ),
            label: items[index].label,
          );
        }),
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
