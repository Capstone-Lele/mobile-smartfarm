import 'package:budidaya_lele_mobile/common/widgets/app_bottom_bar.dart';
import 'package:budidaya_lele_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:budidaya_lele_mobile/features/auth/presentation/pages/splash_page.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/presentation/pages/create_harvest_report_page.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/presentation/pages/harvest_report_detail_page.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/presentation/pages/harvest_report_page.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/pages/create_inventory_report_page.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/pages/create_inventory_submission_page.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/pages/inventory_detail_page.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/pages/inventory_report_detail_page.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/pages/inventory_submission_detail_page.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/pages/update_inventory_report_page.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/pages/update_inventory_submission_page.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/presentation/pages/create_mortality_report_page.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/presentation/pages/mortality_report_detail_page.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/presentation/pages/mortality_report_page.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/presentation/pages/update_mortality_report_page.dart';
import 'package:budidaya_lele_mobile/features/move-pool-report/presentation/pages/create_move_pool_report_page.dart';
import 'package:budidaya_lele_mobile/features/move-pool-report/presentation/pages/move_pool_report_detail_page.dart';
import 'package:budidaya_lele_mobile/features/move-pool-report/presentation/pages/move_pool_report_page.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/presentation/pages/create_pool_cleaning_report_page.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/presentation/pages/pool_cleaning_report_detail_page.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/presentation/pages/pool_cleaning_report_page.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/presentation/pages/update_pool_cleaning_report_page.dart';
import 'package:budidaya_lele_mobile/features/pool/presentation/pages/pool_page.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/presentation/pages/create_sampling_report_page.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/presentation/pages/sampling_report_detail_page.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/presentation/pages/sampling_report_page.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/presentation/pages/update_sampling_report_page.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/pages/create_schedule_page.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/pages/schedule_detail_page.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/pages/update_schedule_page.dart';
import 'package:budidaya_lele_mobile/features/seed-report/presentation/pages/create_seed_report_page.dart';
import 'package:budidaya_lele_mobile/features/seed-report/presentation/pages/seed_report_detail_page.dart';
import 'package:budidaya_lele_mobile/features/seed-report/presentation/pages/seed_report_page.dart';
import 'package:budidaya_lele_mobile/features/sick-report/presentation/pages/create_sick_report_page.dart';
import 'package:budidaya_lele_mobile/features/sick-report/presentation/pages/sick_report_detail_page.dart';
import 'package:budidaya_lele_mobile/features/sick-report/presentation/pages/sick_report_page.dart';
import 'package:budidaya_lele_mobile/features/status-device/presentation/status_device_page.dart';
import 'package:budidaya_lele_mobile/features/user/presentation/pages/change_password_page.dart';
import 'package:budidaya_lele_mobile/features/user/presentation/pages/change_profile_page.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/presentation/pages/create_vitamin_report_page.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/presentation/pages/update_vitamin_report_page.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/presentation/pages/vitamin_report_detail_page.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/presentation/pages/vitamin_report_page.dart';
import 'package:budidaya_lele_mobile/features/feed-report/presentation/pages/create_feeding_report_page.dart';
import 'package:budidaya_lele_mobile/features/feed-report/presentation/pages/feeding_report_detail_page.dart';
import 'package:budidaya_lele_mobile/features/feed-report/presentation/pages/feeding_report_page.dart';
import 'package:budidaya_lele_mobile/features/feed-report/presentation/pages/update_feeding_report_page.dart';
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
  static const String changeProfile = '/change-profile';
  // Mortality Report
  static const String mortalityReport = '/mortality-report';
  static const String createMortalityReport = '/mortality-report/create';
  static const String mortalityReportDetail = '/mortality-report/detail';
  static const String updateMortalityReport = '/mortality-report/update';
  // Seed Report
  static const String seedReport = '/seed-report';
  static const String createSeedReport = '/seed-report/create';
  static const String seedReportDetail = '/seed-report/detail';
  // Vitamin Report
  static const String vitaminReport = '/vitamin-report';
  static const String createVitaminReport = '/vitamin-report/create';
  static const String vitaminReportDetail = '/vitamin-report/detail';
  static const String updateVitaminReport = '/vitamin-report/update';
  // Feeding Report
  static const String feedingReport = '/feeding-report';
  static const String createFeedingReport = '/feeding-report/create';
  static const String feedingReportDetail = '/feeding-report/detail';
  static const String updateFeedingReport = '/feeding-report/update';
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
  // Move Pool Report
  static const String movePoolReport = '/move-pool-report';
  static const String createMovePoolReport = '/move-pool-report/create';
  static const String movePoolReportDetail = '/move-pool-report/detail';
  // Sick Report
  static const String sickReport = '/sick-report';
  static const String createSickReport = '/sick-report/create';
  static const String sickReportDetail = '/sick-report/detail';
  // Pool
  static const String pool = '/pool';
  // Status Device
  static const String statusDevice = '/status-device';
  // Inventory
  static const String inventoryDetail = '/inventory/detail';
  static const String createInventorySubmission =
      '/inventory/create-submission';
  static const String inventorySubmissionDetail =
      '/inventory/submission-detail';
  static const String updateInventorySubmission =
      '/inventory/update-submission';
  static const String createInventoryReport = '/inventory/create-report';
  static const String inventoryReportDetail = '/inventory/report-detail';
  static const String updateInventoryReport = '/inventory/update-report';

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
      changeProfile: (context) => const ChangeProfilePage(),
      // Mortality Report
      mortalityReport: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return MortalityReportPage(
          cycleId: args?['cycleId'] as String? ?? '',
          isCycle: args?['isCycle'] as bool? ?? false,
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
      // Seed Report
      seedReport: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return SeedReportPage(
          isCycle: args?['isCycle'] as bool? ?? false,
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      createSeedReport: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return CreateSeedReportPage(
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      seedReportDetail: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return SeedReportDetailPage(
          reportId: args?['reportId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      // Vitamin Report
      vitaminReport: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return VitaminReportPage(
          cycleId: args?['cycleId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      createVitaminReport: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return CreateVitaminReportPage(
          cycleId: args?['cycleId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      vitaminReportDetail: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return VitaminReportDetailPage(
          reportId: args?['reportId'] as String? ?? '',
          cycleId: args?['cycleId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      updateVitaminReport: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return UpdateVitaminReportPage(
          reportId: args?['reportId'] as String? ?? '',
          cycleId: args?['cycleId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      // Feeding Report
      feedingReport: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return FeedingReportPage(
          cycleId: args?['cycleId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      createFeedingReport: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return CreateFeedingReportPage(
          cycleId: args?['cycleId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      feedingReportDetail: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return FeedingReportDetailPage(
          reportId: args?['reportId'] as String? ?? '',
          cycleId: args?['cycleId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      updateFeedingReport: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return UpdateFeedingReportPage(
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
          isCycle: args?['isCycle'] as bool? ?? false,
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
          isCycle: args?['isCycle'] as bool? ?? false,
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
          isCycle: args?['isCycle'] as bool? ?? false,
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
      // Move Pool Report
      movePoolReport: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return MovePoolReportPage(
          cycleId: args?['cycleId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      createMovePoolReport: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return CreateMovePoolReportPage(
          cycleId: args?['cycleId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      movePoolReportDetail: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return MovePoolReportDetailPage(
          reportId: args?['reportId'] as String? ?? '',
          cycleId: args?['cycleId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      // Sick Report
      sickReport: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return SickReportPage(
          cycleId: args?['cycleId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      createSickReport: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return CreateSickReportPage(
          cycleId: args?['cycleId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      sickReportDetail: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return SickReportDetailPage(
          reportId: args?['reportId'] as String? ?? '',
          cycleId: args?['cycleId'] as String? ?? '',
          poolId: args?['poolId'] as String? ?? '',
          poolName: args?['poolName'] as String? ?? '',
        );
      },
      // Pool
      pool: (context) => const PoolPage(),
      // Status Device
      statusDevice: (context) => const StatusDevicePage(),
      // Inventory
      inventoryDetail: (context) => const InventoryDetailPage(),
      createInventorySubmission: (context) =>
          const CreateInventorySubmissionPage(),
      inventorySubmissionDetail: (context) =>
          const InventorySubmissionDetailPage(),
      updateInventorySubmission: (context) =>
          const UpdateInventorySubmissionPage(),
      createInventoryReport: (context) => const CreateInventoryReportPage(),
      inventoryReportDetail: (context) => const InventoryReportDetailPage(),
      updateInventoryReport: (context) => const UpdateInventoryReportPage(),
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
