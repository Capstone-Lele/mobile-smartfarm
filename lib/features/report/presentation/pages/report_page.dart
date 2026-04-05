import 'package:budidaya_lele_mobile/common/widgets/app_hint_board.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_dropdown.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_loading.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_segmented_control.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_status_badge.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/user/presentation/providers/user_provider.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/pool/presentation/providers/pool_provider.dart';
import 'package:budidaya_lele_mobile/features/report/domain/entities/activity_log.dart';
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

  final List<Map<String, String>> _activities = [
    {
      'tag': '#Kolam 1',
      'title': 'Pak Adib telah melaporkan kematian',
      'subtitle': 'Senin, 29 September 2025 08:30',
    },
    {
      'tag': '#Kolam 2',
      'title': 'Pak Adib telah melaporkan hasil panen',
      'subtitle': 'Minggu, 28 September 2025 09:30',
    },
    {
      'tag': '#Kolam 3',
      'title': 'Pak Adib telah melaporkan tebar benih',
      'subtitle': 'Sabtu, 27 September 2025 11:30',
    },
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(poolListNotifierProvider.notifier).getPools();
      ref.read(activityLogListNotifierProvider.notifier).getActivityLogs();
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
            setState(() {
              _selectedPool = null;
            });
            await ref.read(poolListNotifierProvider.notifier).getPools();
            await ref
                .read(activityLogListNotifierProvider.notifier)
                .getActivityLogs();
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
                  _buildPoolListSection(poolsAsync),
                  const SizedBox(height: 16),
                  // _buildActivitiesSection(activityLogsAsync),
                  _buildActivitiesSection(),
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ReportQuickActionBottomSheet(type: type),
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
                  'cycleId': 'cycle-1',
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _selectedPool != null
              ? 'Statistik Laporan ${_selectedPool!.name} Bulan Ini'
              : 'Statistik Laporan Keseluruhan Kolam Bulan Ini',
          style: TextStyle(
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
        _buildStatisticsGrid(selectedStatisticIndex),
      ],
    );
  }

  Widget _buildStatisticsGrid(int selectedStatisticIndex) {
    if (selectedStatisticIndex == 0) {
      return GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.95,
        children: const [
          ReportStatisticsCard(
            label: 'Laporan Pakan',
            count: 12,
            icon: Icons.article,
          ),
          ReportStatisticsCard(
            label: 'Laporan Vitamin',
            count: 20,
            icon: Icons.article,
          ),
          ReportStatisticsCard(
            label: 'Laporan Kematian',
            count: 30,
            icon: Icons.article,
          ),
          ReportStatisticsCard(
            label: 'Laporan Sakit',
            count: 12,
            icon: Icons.article,
          ),
          ReportStatisticsCard(
            label: 'Laporan Pembersihan Kolam',
            count: 12,
            icon: Icons.article,
          ),
          ReportStatisticsCard(
            label: 'Laporan Sampling',
            count: 12,
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
        children: const [
          ReportStatisticsCard(
            label: 'Laporan Tebar Benih',
            count: 12,
            icon: Icons.article,
          ),
          ReportStatisticsCard(
            label: 'Laporan Panen',
            count: 20,
            icon: Icons.article,
          ),
          ReportStatisticsCard(
            label: 'Laporan Pindah Kolam',
            count: 30,
            icon: Icons.article,
          ),
        ],
      );
    }
  }

  Widget _buildPoolListSection(AsyncValue<List<Pool>> poolsAsync) {
    return poolsAsync.when(
      loading: () => Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daftar Kolam',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                AppLoading(height: 100, borderRadius: 8),
          ),
        ],
      ),
      error: (err, stack) => Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daftar Kolam',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Gagal memuat daftar kolam',
            style: TextStyle(color: AppColors.red),
          ),
        ],
      ),
      data: (pools) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Daftar Kolam',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGray,
                ),
              ),
              GestureDetector(
                onTap: () {
                  AppRoutes.pushNamed(context, AppRoutes.pool);
                },
                child: const Text(
                  'Lihat Kolam',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkGray,
                    decoration: TextDecoration.underline,
                    decorationThickness: 1,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (pools.length > 3 ? 3 : pools.length),
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final pool = pools[index];
              return _buildPoolItem(pool);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPoolItem(Pool pool) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.darkGray),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://source.unsplash.com/60x60/?pond,fish',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60,
                      height: 60,
                      color: AppColors.gray,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            pool.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          AppStatusBadge(
                            label: pool.categoryLabel,
                            type: pool.categoryLabel == 'Pembenihan'
                                ? BadgeType.warning
                                : pool.categoryLabel == 'Pembesaran'
                                ? BadgeType.success
                                : BadgeType.danger,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            // 'Jumlah Ikan Saat ini ${pool.currentQuantity} Ekor',
                            'Jumlah Ikan Saat ini 1000 Ekor Bug',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.darkGray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivitiesSection() {
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
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.gray),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: _activities
                .asMap()
                .entries
                .map(
                  (entry) => ReportActivityItem(
                    tag: entry.value['tag']!,
                    title: entry.value['title']!,
                    subtitle: entry.value['subtitle']!,
                    isLast: entry.key == _activities.length - 1,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  // Widget _buildActivitiesSection(
  //   AsyncValue<List<ActivityLog>> activityLogsAsync,
  // ) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         'Aktivitas Terbaru',
  //         style: TextStyle(
  //           fontSize: 14,
  //           fontWeight: FontWeight.w600,
  //           color: AppColors.darkGray,
  //         ),
  //       ),
  //       const SizedBox(height: 8),
  //       activityLogsAsync.when(
  //         loading: () => AppLoading(height: 300, borderRadius: 8),
  //         error: (err, stack) => Center(
  //           child: Text(
  //             'Gagal memuat aktivitas terbaru',
  //             style: TextStyle(color: AppColors.red),
  //           ),
  //         ),
  //         data: (activityLogs) => Container(
  //           decoration: BoxDecoration(
  //             border: Border.all(color: AppColors.gray),
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: Column(
  //             children: activityLogs
  //                 .asMap()
  //                 .entries
  //                 .map(
  //                   (entry) => ReportActivityItem(
  //                     tag: '#${entry.value.poolName}',
  //                     title:
  //                         '${entry.value.user} telah melaporkan ${entry.value.activity}',
  //                     subtitle: entry.value.createdAt,
  //                     isLast: entry.key == activityLogs.length - 1,
  //                   ),
  //                 )
  //                 .toList(),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
