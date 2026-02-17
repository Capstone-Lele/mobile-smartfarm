import 'package:budidaya_lele_mobile/common/widgets/app_hint_board.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_dropdown.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_loading.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_segmented_control.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/features/auth/presentation/providers/user_provider.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/pool/presentation/providers/pool_provider.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final poolsAsync = ref.watch(poolListNotifierProvider);
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
            hint: 'Pilih kolam',
            items: pools,
            itemLabel: (pool) => pool.name,
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
            onTap: () {},
          ),
          ReportMenuCard(
            icon: Icons.medical_services,
            label: 'Laporan Vitamin',
            onTap: () {},
          ),
          ReportMenuCard(
            icon: Icons.dangerous,
            label: 'Laporan Kematian',
            onTap: () {},
          ),
          ReportMenuCard(
            icon: Icons.error_outline,
            label: 'Laporan Sakit',
            onTap: () {},
          ),
          ReportMenuCard(
            icon: Icons.water_drop,
            label: 'Laporan Pembersihan',
            onTap: () {},
          ),
          ReportMenuCard(
            icon: Icons.trending_up,
            label: 'Laporan Sampling',
            onTap: () {},
          ),
        ],
      );
    } else {
      // Laporan Khusus
      return GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
        children: [
          ReportMenuCard(
            icon: Icons.add_circle_outline,
            label: 'Laporan Tebar Benih',
            onTap: () {},
          ),
          ReportMenuCard(
            icon: Icons.agriculture,
            label: 'Laporan Panen',
            onTap: () {},
          ),
          ReportMenuCard(
            icon: Icons.swap_horiz,
            label: 'Laporan Pindah Kolam',
            onTap: () {},
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
}
