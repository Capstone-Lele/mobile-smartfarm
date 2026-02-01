import 'package:budidaya_lele_mobile/common/widgets/app_bottom_bar.dart';
import 'package:budidaya_lele_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:budidaya_lele_mobile/features/auth/presentation/pages/splash_page.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/pages/create_schedule_page.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/pages/schedule_detail_page.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/pages/update_schedule_page.dart';
import 'package:budidaya_lele_mobile/features/seed-report/presentation/seed_report_page.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/presentation/mortality_report_page.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/presentation/vitamin_report_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static const String splash = '/';
  static const String dashboard = '/dashboard';
  static const String login = '/login';
  static const String scheduleDetail = '/schedule/detail';
  static const String createSchedule = '/schedule/create';
  static const String updateSchedule = '/schedule/update';
  static const String seedReport = '/seed-report';
  static const String mortalityReport = '/mortality-report';
  static const String vitaminReport = '/vitamin-report';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashPage(),
      dashboard: (context) => const AppBottomBar(),
      login: (context) => const LoginPage(),
      scheduleDetail: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return ScheduleDetailPage(
          scheduleId: args?['scheduleId'] as String? ?? '',
          scheduleType: args?['scheduleType'] as String? ?? '',
        );
      },
      createSchedule: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return CreateSchedulePage(
          scheduleType: args?['scheduleType'] as String? ?? '',
        );
      },
      updateSchedule: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return UpdateSchedulePage(
          scheduleId: args?['scheduleId'] as String? ?? '',
          scheduleType: args?['scheduleType'] as String? ?? '',
        );
      },
      seedReport: (context) => const SeedReportPage(),
      mortalityReport: (context) => const MortalityReportPage(),
      vitaminReport: (context) => const VitaminReportPage(),
    };
  }

  static Future<dynamic> pushNamed(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static Future<dynamic> pushReplacementNamed(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  static Future<dynamic> pushNamedAndRemoveUntil(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  static void pop(BuildContext context, [dynamic result]) {
    Navigator.pop(context, result);
  }
}
