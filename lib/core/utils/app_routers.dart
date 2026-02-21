import 'package:budidaya_lele_mobile/common/widgets/app_bottom_bar.dart';
import 'package:budidaya_lele_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:budidaya_lele_mobile/features/auth/presentation/pages/splash_page.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/presentation/create_harvest_report_page.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/presentation/harvest_report_detail_page.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/presentation/harvest_report_page.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/presentation/pages/create_mortality_report_page.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/presentation/pages/mortality_report_detail_page.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/presentation/pages/mortality_report_page.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/presentation/pages/update_mortality_report_page.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/presentation/pages/create_pool_cleaning_report_page.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/presentation/pages/pool_cleaning_report_detail_page.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/presentation/pages/pool_cleaning_report_page.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/presentation/pages/update_pool_cleaning_report_page.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/presentation/pages/create_sampling_report_page.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/presentation/pages/sampling_report_detail_page.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/presentation/pages/sampling_report_page.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/presentation/pages/update_sampling_report_page.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/pages/create_schedule_page.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/pages/schedule_detail_page.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/pages/update_schedule_page.dart';
import 'package:budidaya_lele_mobile/features/user/presentation/pages/change_password_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static const String dashboard = '/dashboard';
  // Auth
  static const String splash = '/';
  static const String login = '/login';
  // Schedule
  static const String scheduleDetail = '/schedule/detail';
  static const String createSchedule = '/schedule/create';
  static const String updateSchedule = '/schedule/update';
  // User
  static const String changePassword = '/change-password';
  // Mortality Report
  static const String mortalityReport = '/mortality-report';
  static const String createMortalityReport = '/mortality-report/create';
  static const String mortalityReportDetail = '/mortality-report/detail';
  static const String updateMortalityReport = '/mortality-report/update';
  // Pool Cleaning Report
  static const String poolCleaningReport = '/pool-cleaning-report';
  static const String createPoolCleaningReport = '/pool-cleaning-report/create';
  static const String poolCleaningReportDetail = '/pool-cleaning-report/detail';
  static const String updatePoolCleaningReport = '/pool-cleaning-report/update';
  // Sampling Report
  static const String samplingReport = '/sampling-report';
  static const String createSamplingReport = '/sampling-report/create';
  static const String samplingReportDetail = '/sampling-report/detail';
  static const String updateSamplingReport = '/sampling-report/update';
  // Harvest Report
  static const String harvestReport = '/harvest-report';
  static const String createHarvestReport = '/harvest-report/create';
  static const String harvestReportDetail = '/harvest-report/detail';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      dashboard: (context) => const AppBottomBar(),
      // Auth
      splash: (context) => const SplashPage(),
      login: (context) => const LoginPage(),
      // Schedule
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
      // User
      changePassword: (context) => const ChangePasswordPage(),
      // Mortality Report
      mortalityReport: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return MortalityReportPage(
          cycleId: args?['cycleId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      createMortalityReport: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return CreateMortalityReportPage(
          cycleId: args?['cycleId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      mortalityReportDetail: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return MortalityReportDetailPage(
          reportId: args?['reportId'] as String? ?? '',
          cycleId: args?['cycleId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      updateMortalityReport: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return UpdateMortalityReportPage(
          reportId: args?['reportId'] as String? ?? '',
          cycleId: args?['cycleId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      // Pool Cleaning Report
      poolCleaningReport: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return PoolCleaningReportPage(
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      createPoolCleaningReport: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return CreatePoolCleaningReportPage(
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      poolCleaningReportDetail: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return PoolCleaningReportDetailPage(
          reportId: args?['reportId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      updatePoolCleaningReport: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return UpdatePoolCleaningReportPage(
          reportId: args?['reportId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      // Sampling Report
      samplingReport: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return SamplingReportPage(
          cycleId: args?['cycleId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      createSamplingReport: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return CreateSamplingReportPage(
          cycleId: args?['cycleId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      samplingReportDetail: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return SamplingReportDetailPage(
          reportId: args?['reportId'] as String? ?? '',
          cycleId: args?['cycleId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      updateSamplingReport: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return UpdateSamplingReportPage(
          reportId: args?['reportId'] as String? ?? '',
          cycleId: args?['cycleId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      // Harvest Report
      harvestReport: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return HarvestReportPage(
          cycleId: args?['cycleId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      createHarvestReport: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return CreateHarvestReportPage(
          cycleId: args?['cycleId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      harvestReportDetail: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return HarvestReportDetailPage(
          reportId: args?['reportId'] as String? ?? '',
          cycleId: args?['cycleId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
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
