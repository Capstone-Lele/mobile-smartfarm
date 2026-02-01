import 'package:budidaya_lele_mobile/common/widgets/app_loading.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_status_badge.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_format.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/auth/presentation/providers/user_provider.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/grouped_schedules.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/schedule.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/providers/cleaning_provider.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/providers/feeding_provider.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/providers/sampling_provider.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/providers/schedule_provider.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/widgets/schedule_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_segmented_control.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/widgets/schedule_summary_card.dart';

class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage({super.key});

  @override
  ConsumerState<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _initializeAllSchedules();
    });
  }

  Future<void> _initializeAllSchedules() async {
    await Future.wait([
      ref.read(cleaningListNotifierProvider.notifier).getCleaningSchedules(),
      ref.read(feedingListNotifierProvider.notifier).getFeedingSchedules(),
      ref.read(samplingListNotifierProvider.notifier).getSamplingSchedules(),
    ]);
  }

  Future<void> _refreshData() async {
    final selectedTab = ref.read(scheduleTabProvider);
    switch (selectedTab) {
      case 0:
        await ref
            .read(cleaningListNotifierProvider.notifier)
            .getCleaningSchedules();
        break;
      case 1:
        await ref
            .read(feedingListNotifierProvider.notifier)
            .getFeedingSchedules();
        break;
      case 2:
        await ref
            .read(samplingListNotifierProvider.notifier)
            .getSamplingSchedules();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final selectedTab = ref.watch(scheduleTabProvider);
    final scheduleAsync = ref.watch(activeScheduleProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  if (user?.role == 'pic') ...[
                    SizedBox(height: 20),
                    _buildSummarySection(),
                  ],
                  const SizedBox(height: 20),
                  _buildSegmentedControl(selectedTab),
                  const SizedBox(height: 16),
                  _buildScheduleContent(scheduleAsync),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Menu Aplikasi",
          style: TextStyle(fontSize: 14, color: AppColors.darkGray),
        ),
        Text(
          "Jadwal",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSummarySection() {
    return ref
        .watch(scheduleSummaryProvider)
        .when(
          data: (summary) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ScheduleSummaryCard(
                title: "Total Jadwal",
                value: summary.total.toString(),
              ),
              ScheduleSummaryCard(
                title: "Hari Ini",
                value: summary.today.toString(),
              ),
              ScheduleSummaryCard(
                title: "Mendatang",
                value: summary.upcoming.toString(),
              ),
            ],
          ),
          loading: () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              3,
              (index) => AppLoading(
                width: 80,
                height: 80,
                margin: EdgeInsets.symmetric(horizontal: 2),
              ),
            ),
          ),
          error: (error, stack) =>
              Center(child: Text("Gagal memuat data: $error")),
        );
  }

  Widget _buildSegmentedControl(int selectedTab) {
    return AppSegmentedControl(
      selectedIndex: selectedTab,
      children: const ["Pembersihan Kolam", "Pakan", "Sampling"],
      onValueChanged: (index) {
        ref.read(scheduleTabProvider.notifier).state = index;
      },
    );
  }

  Widget _buildScheduleContent(AsyncValue<List<Schedule>> scheduleAsync) {
    return ref
        .watch(scheduleContentProvider)
        .when(
          loading: () => _buildLoadingState(),
          error: (err, stack) => _buildErrorState(err),
          data: (grouped) {
            if (grouped.isEmpty) {
              return _buildEmptyState();
            }
            return _buildSchedulesList(grouped);
          },
        );
  }

  Widget _buildLoadingState() {
    return Column(
      children: List.generate(
        3,
        (index) =>
            AppLoading(height: 120, margin: EdgeInsets.symmetric(vertical: 8)),
      ),
    );
  }

  Widget _buildErrorState(dynamic error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Text("Gagal memuat data: $error"),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Text("Tidak ada jadwal"),
      ),
    );
  }

  Widget _buildSchedulesList(GroupedSchedules grouped) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildScheduleSection(
          title: "Hari Ini",
          schedules: grouped.today,
          statusLabel: "Hari Ini",
          statusType: BadgeType.success,
        ),
        _buildScheduleSection(
          title: "Jadwal Mendatang",
          schedules: grouped.upcoming,
          statusLabel: "Mendatang",
          statusType: BadgeType.warning,
        ),
        _buildScheduleSection(
          title: "Jadwal Kemarin",
          schedules: grouped.past,
          statusLabel: "Kemarin",
          statusType: BadgeType.danger,
        ),
      ],
    );
  }

  Widget _buildScheduleSection({
    required String title,
    required List<Schedule> schedules,
    required String statusLabel,
    required BadgeType statusType,
  }) {
    if (schedules.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGray,
            ),
          ),
        ),
        ...schedules.map((schedule) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: GestureDetector(
              onTap: () {
                AppRoutes.pushNamed(
                  context,
                  AppRoutes.scheduleDetail,
                  arguments: {
                    'scheduleType': schedule.type,
                    'scheduleId': schedule.id,
                  },
                );
              },
              child: ScheduleCard(
                title: schedule.poolName,
                description: "Jadwal ${schedule.typeLabel}",
                time: AppFormat.dateTime(schedule.scheduleDate),
                officer: schedule.userName,
                statusLabel: statusLabel,
                statusType: statusType,
              ),
            ),
          );
        }),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    final selectedTab = ref.watch(scheduleTabProvider);
    final scheduleTypeMap = {0: 'cleaning', 1: 'feeding', 2: 'sampling'};

    return FloatingActionButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: AppColors.secondary,
      onPressed: () {
        AppRoutes.pushNamed(
          context,
          AppRoutes.createSchedule,
          arguments: {'scheduleType': scheduleTypeMap[selectedTab]},
        );
      },
      child: const Icon(Icons.add, color: Colors.white, size: 30),
    );
  }
}
