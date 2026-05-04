import 'package:budidaya_lele_mobile/common/widgets/app_hint_board.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_dropdown.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_loading.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_segmented_control.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_format.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/user/presentation/providers/user_provider.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/pool/presentation/providers/pool_provider.dart';
import 'package:budidaya_lele_mobile/features/report/domain/entities/activity_log.dart';
import 'package:budidaya_lele_mobile/features/report/domain/entities/total_report.dart';
import 'package:budidaya_lele_mobile/features/report/presentation/providers/report_provider.dart';
import 'package:budidaya_lele_mobile/features/report/presentation/widgets/report_activity_item.dart';
import 'package:budidaya_lele_mobile/features/report/presentation/widgets/report_menu_card.dart';
import 'package:budidaya_lele_mobile/features/report/presentation/widgets/report_quick_action_bottom_sheet.dart';
import 'package:budidaya_lele_mobile/features/report/presentation/widgets/report_quick_action_card.dart';
import 'package:budidaya_lele_mobile/features/report/presentation/widgets/report_statistics_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportPage extends ConsumerStatefulWidget {
  const ReportPage({super.key});

  @override
  ConsumerState<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage> {
  Pool? _selectedPool;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(poolListNotifierProvider.notifier).getPools();
      ref.read(activityLogListNotifierProvider.notifier).getActivityLogs();
      ref.read(totalReportsNotifierProvider.notifier).getTotalReports(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final poolsAsync = ref.watch(poolListNotifierProvider);
    final activityLogsAsync = ref.watch(activityLogListNotifierProvider);
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(poolListNotifierProvider.notifier).getPools();
            await ref
                .read(activityLogListNotifierProvider.notifier)
                .getActivityLogs();
            if (_selectedPool != null) {
              await ref
                  .read(totalReportsByPoolNotifierProvider.notifier)
                  .getTotalReportsByPool(_selectedPool!.id, 1);
            } else {
              await ref
                  .read(totalReportsNotifierProvider.notifier)
                  .getTotalReports(1);
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  const AppHintBoard(
                    title: 'Kelola budidaya lele lebih mudah dan efisien.',
                    desc:
                        'Pantau perkembangan kolam, lapor aktivitas penting, dan tingkatkan hasil panenmu!',
                  ),
                  const SizedBox(height: 16),
                  _buildPoolSelector(poolsAsync),
                  if (_selectedPool != null && user?.role == 'staff') ...[
                    const SizedBox(height: 16),
                    _buildQuickActionSection(),
                  ],
                  if (_selectedPool != null) ...[
                    const SizedBox(height: 16),
                    _buildReportMenuSection(),
                  ],
                  const SizedBox(height: 16),
                  if (user?.role == 'pic') ...[
                    _buildStatisticsSection(),
                    const SizedBox(height: 16),
                  ],
                  // _buildPoolListSection(poolsAsync),
                  // const SizedBox(height: 16),
                  _buildActivitiesSection(activityLogsAsync),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Menu Aplikasi",
          style: TextStyle(fontSize: 14, color: AppColors.darkGray),
        ),
        Text(
          "Laporan",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPoolSelector(AsyncValue<List<Pool>> poolsAsync) {
    return poolsAsync.when(
      loading: () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Pilih Kolam Terlebih Dahulu',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          SizedBox(height: 8),
          AppLoading(height: 50, borderRadius: 8),
        ],
      ),
      error: (error, stack) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pilih Kolam Terlebih Dahulu',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 8),
          AppInputDropdown<Pool>(
            hint: 'Gagal memuat kolam',
            items: const [],
            itemLabel: (pool) => pool.name,
            value: null,
            readOnly: true,
          ),
        ],
      ),
      data: (pools) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pilih Kolam Terlebih Dahulu',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 8),
          AppInputDropdown<Pool>(
            hint: 'Semua kolam',
            items: pools,
            itemLabel: (pool) => '${pool.name} - ${pool.categoryLabel}',
            value: _selectedPool,
            onChanged: (pool) {
              setState(() {
                _selectedPool = pool;
              });
              if (pool != null) {
                ref
                    .read(totalReportsByPoolNotifierProvider.notifier)
                    .getTotalReportsByPool(pool.id, 1);
              } else {
                ref
                    .read(totalReportsNotifierProvider.notifier)
                    .getTotalReports(1);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aksi Cepat',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGray,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ReportQuickActionCard(
                title: 'Tambah Laporan Harian',
                description:
                    'Tambahkan laporan kegiatan kolam hari ini, mulai dari pakan, vitamin, hingga kondisi ikan.',
                backgroundColor: AppColors.primary,
                onTap: () => _showBottomSheet(context, 'daily'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ReportQuickActionCard(
                title: 'Tambah Laporan Khusus',
                description:
                    'Tambahkan laporan kegiatan penting seperti tebar benih, panen, atau inventori.',
                backgroundColor: AppColors.secondary,
                onTap: () => _showBottomSheet(context, 'special'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showBottomSheet(BuildContext context, String type) {
    if (_selectedPool == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ReportQuickActionBottomSheet(
        type: type,
        poolId: _selectedPool!.id,
        poolName: _selectedPool!.name,
        cycleId: _selectedPool!.cycleId ?? '',
      ),
    );
  }

  Widget _buildReportMenuSection() {
    final selectedMenuIndex = ref.watch(selectedMenuIndexProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Menu Laporan',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGray,
          ),
        ),
        const SizedBox(height: 12),
        AppSegmentedControl(
          children: const ["Laporan Harian", "Laporan Khusus"],
          selectedIndex: selectedMenuIndex,
          onValueChanged: (index) {
            ref.read(selectedMenuIndexProvider.notifier).state = index;
          },
        ),
        if (_selectedPool?.cycle != 'active_cultivation') ...[
          const SizedBox(height: 8),
          Text(
            'Siklus tidak aktif, silahkan menambahkan laporan tebar benih untuk mengaktifkan siklus',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.red,
            ),
          ),
        ],
        const SizedBox(height: 16),
        _buildReportMenuGrid(selectedMenuIndex),
      ],
    );
  }

  Widget _buildReportMenuGrid(int selectedMenuIndex) {
    final String category = _selectedPool?.category ?? '';
    final isGrowing = category.contains('growing');
    final isBreeding = category.contains('breeding');

    if (selectedMenuIndex == 0) {
      return GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
        children: [
          ReportMenuCard(
            icon: Icons.restaurant,
            label: 'Laporan Pakan',
            onTap: () {
              AppRoutes.pushNamed(
                context,
                AppRoutes.feedingReport,
                arguments: {
                  'cycleId': _selectedPool!.cycleId,
                  'isCycle': _selectedPool!.cycle == 'active_cultivation',
                  'poolId': _selectedPool!.id,
                  'poolName': _selectedPool!.name,
                },
              );
            },
          ),
          ReportMenuCard(
            icon: Icons.medical_services,
            label: 'Laporan Vitamin',
            onTap: () {
              AppRoutes.pushNamed(
                context,
                AppRoutes.vitaminReport,
                arguments: {
                  'cycleId': _selectedPool!.cycleId,
                  'isCycle': _selectedPool!.cycle == 'active_cultivation',
                  'poolId': _selectedPool!.id,
                  'poolName': _selectedPool!.name,
                },
              );
            },
          ),
          ReportMenuCard(
            icon: Icons.dangerous,
            label: 'Laporan Kematian',
            onTap: () {
              AppRoutes.pushNamed(
                context,
                AppRoutes.mortalityReport,
                arguments: {
                  'cycleId': _selectedPool!.cycleId,
                  'isCycle': _selectedPool!.cycle == 'active_cultivation',
                  'poolId': _selectedPool!.id,
                  'poolName': _selectedPool!.name,
                },
              );
            },
          ),
          if (isGrowing || isBreeding)
            ReportMenuCard(
              icon: Icons.error_outline,
              label: 'Laporan Sakit',
              onTap: () {
                AppRoutes.pushNamed(
                  context,
                  AppRoutes.sickReport,
                  arguments: {
                    'cycleId': _selectedPool!.cycleId,
                    'isCycle': _selectedPool!.cycle == 'active_cultivation',
                    'poolId': _selectedPool!.id,
                    'poolName': _selectedPool!.name,
                  },
                );
              },
            ),
          ReportMenuCard(
            icon: Icons.water_drop,
            label: 'Laporan Pembersihan',
            onTap: () {
              AppRoutes.pushNamed(
                context,
                AppRoutes.poolCleaningReport,
                arguments: {
                  'isCycle': _selectedPool!.cycle == 'active_cultivation',
                  'poolId': _selectedPool!.id,
                  'poolName': _selectedPool!.name,
                },
              );
            },
          ),
          ReportMenuCard(
            icon: Icons.trending_up,
            label: 'Laporan Sampling',
            onTap: () {
              AppRoutes.pushNamed(
                context,
                AppRoutes.samplingReport,
                arguments: {
                  'cycleId': _selectedPool!.cycleId,
                  'isCycle': _selectedPool!.cycle == 'active_cultivation',
                  'poolId': _selectedPool!.id,
                  'poolName': _selectedPool!.name,
                },
              );
            },
          ),
        ],
      );
    } else {
      return GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
        children: [
          if (isBreeding)
            ReportMenuCard(
              icon: Icons.add_circle_outline,
              label: 'Laporan Tebar Benih',
              onTap: () {
                AppRoutes.pushNamed(
                  context,
                  AppRoutes.seedReport,
                  arguments: {
                    'isCycle': _selectedPool!.cycle == 'active_cultivation',
                    'poolId': _selectedPool!.id,
                    'poolName': _selectedPool!.name,
                  },
                );
              },
            ),
          if (isGrowing)
            ReportMenuCard(
              icon: Icons.agriculture,
              label: 'Laporan Panen',
              onTap: () {
                AppRoutes.pushNamed(
                  context,
                  AppRoutes.harvestReport,
                  arguments: {
                    'cycleId': _selectedPool!.cycleId,
                    'isCycle': _selectedPool!.cycle == 'active_cultivation',
                    'poolId': _selectedPool!.id,
                    'poolName': _selectedPool!.name,
                  },
                );
              },
            ),
          ReportMenuCard(
            icon: Icons.swap_horiz,
            label: 'Laporan Pindah Kolam',
            onTap: () {
              AppRoutes.pushNamed(
                context,
                AppRoutes.movePoolReport,
                arguments: {
                  'cycleId': _selectedPool!.cycleId,
                  'isCycle': _selectedPool!.cycle == 'active_cultivation',
                  'poolId': _selectedPool!.id,
                  'poolName': _selectedPool!.name,
                },
              );
            },
          ),
        ],
      );
    }
  }

  Widget _buildStatisticsSection() {
    final selectedStatisticIndex = ref.watch(selectedStatisticIndexProvider);
    final statsAsync = _selectedPool != null
        ? ref.watch(totalReportsByPoolNotifierProvider)
        : ref.watch(totalReportsNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _selectedPool != null
              ? 'Statistik Laporan ${_selectedPool!.name} Bulan Ini'
              : 'Statistik Laporan Keseluruhan Kolam Bulan Ini',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGray,
          ),
        ),
        const SizedBox(height: 12),
        AppSegmentedControl(
          children: const ["Laporan Harian", "Laporan Khusus"],
          selectedIndex: selectedStatisticIndex,
          onValueChanged: (index) {
            ref.read(selectedStatisticIndexProvider.notifier).state = index;
          },
        ),
        const SizedBox(height: 16),
        statsAsync.when(
          loading: () => Column(
            children: [
              Row(
                children: [
                  Expanded(child: AppLoading(height: 100, borderRadius: 12)),
                  const SizedBox(width: 8),
                  Expanded(child: AppLoading(height: 100, borderRadius: 12)),
                  const SizedBox(width: 8),
                  Expanded(child: AppLoading(height: 100, borderRadius: 12)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: AppLoading(height: 100, borderRadius: 12)),
                  const SizedBox(width: 8),
                  Expanded(child: AppLoading(height: 100, borderRadius: 12)),
                  const SizedBox(width: 8),
                  Expanded(child: AppLoading(height: 100, borderRadius: 12)),
                ],
              ),
            ],
          ),
          error: (error, stack) => const Center(
            child: Text(
              'Gagal memuat statistik laporan',
              style: TextStyle(color: AppColors.red),
            ),
          ),
          data: (totalReport) {
            if (totalReport == null) {
              return const Center(
                child: Text(
                  'Data tidak tersedia',
                  style: TextStyle(color: AppColors.darkGray),
                ),
              );
            }
            return _buildStatisticsGrid(selectedStatisticIndex, totalReport);
          },
        ),
      ],
    );
  }

  Widget _buildStatisticsGrid(
    int selectedStatisticIndex,
    TotalReport totalReport,
  ) {
    if (selectedStatisticIndex == 0) {
      return GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.95,
        children: [
          ReportStatisticsCard(
            label: 'Laporan Pakan',
            count: totalReport.totalFeedNotes,
            icon: Icons.article,
          ),
          ReportStatisticsCard(
            label: 'Laporan Vitamin',
            count: totalReport.totalVitaminNotes,
            icon: Icons.article,
          ),
          ReportStatisticsCard(
            label: 'Laporan Kematian',
            count: totalReport.totalMortalityNotes,
            icon: Icons.article,
          ),
          ReportStatisticsCard(
            label: 'Laporan Sakit',
            count: totalReport.totalSickNotes,
            icon: Icons.article,
          ),
          ReportStatisticsCard(
            label: 'Laporan Pembersihan Kolam',
            count: totalReport.totalCleaningNotes,
            icon: Icons.article,
          ),
          ReportStatisticsCard(
            label: 'Laporan Sampling',
            count: totalReport.totalSamplingNotes,
            icon: Icons.article,
          ),
        ],
      );
    } else {
      return GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.95,
        children: [
          ReportStatisticsCard(
            label: 'Laporan Tebar Benih',
            count: totalReport.totalSeedNotes,
            icon: Icons.article,
          ),
          ReportStatisticsCard(
            label: 'Laporan Panen',
            count: totalReport.totalHarvestNotes,
            icon: Icons.article,
          ),
          ReportStatisticsCard(
            label: 'Laporan Pindah Kolam',
            count: totalReport.totalMovePoolNotes,
            icon: Icons.article,
          ),
        ],
      );
    }
  }

  Widget _buildActivitiesSection(
    AsyncValue<List<ActivityLog>> activityLogsAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aktivitas Terbaru',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkGray,
          ),
        ),
        const SizedBox(height: 8),
        activityLogsAsync.when(
          loading: () => AppLoading(height: 300, borderRadius: 8),
          error: (err, stack) => Center(
            child: Text(
              'Gagal memuat aktivitas terbaru',
              style: TextStyle(color: AppColors.red),
            ),
          ),
          data: (activityLogs) => activityLogs.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      'Belom ada aktifitas terbaru',
                      style: TextStyle(fontSize: 14, color: AppColors.darkGray),
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.gray),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: activityLogs
                        .asMap()
                        .entries
                        .map(
                          (entry) => ReportActivityItem(
                            tag: '#${entry.value.poolName}',
                            title: AppFormat.activityLog(
                              entry.value.userName,
                              entry.value.activity,
                              entry.value.notes,
                            ),
                            subtitle: AppFormat.dateTime(entry.value.createdAt),
                            isLast: entry.key == activityLogs.length - 1,
                          ),
                        )
                        .toList(),
                  ),
                ),
        ),
      ],
    );
  }
}
