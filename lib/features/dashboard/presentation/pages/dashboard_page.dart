import 'package:budidaya_lele_mobile/common/widgets/app_header.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_dropdown.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_loading.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_status_badge.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/dashboard/presentation/widgets/dashboard_summary_card.dart';
import 'package:budidaya_lele_mobile/features/dashboard/presentation/widgets/dashboard_pool_status_card.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/pool/presentation/providers/pool_provider.dart';
import 'package:budidaya_lele_mobile/features/user/domain/entities/user.dart';
import 'package:budidaya_lele_mobile/features/user/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  Pool? _selectedPool;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(poolListNotifierProvider.notifier).getPools();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final poolsAsync = ref.watch(poolListNotifierProvider);

    // Initial selected pool setup
    poolsAsync.whenData((pools) {
      if (pools.isNotEmpty && _selectedPool == null) {
        setState(() {
          _selectedPool = pools.first;
        });
      }
    });

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
                  _buildHeader(user, context),
                  const SizedBox(height: 16),
                  _buildPoolSelector(poolsAsync),
                  const SizedBox(height: 16),
                  Text(
                    'Ringkasan Kondisi ${_selectedPool?.name ?? ""}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGray,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryPoolConditions(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Status ${_selectedPool?.name ?? ""}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkGray,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          AppRoutes.pushNamed(context, AppRoutes.poolCondition);
                        },
                        child: const Text(
                          'Lihat Semua',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkGray,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DashboardPoolStatusCard(
                    poolName: _selectedPool?.name ?? 'Kolam 1',
                    temperature: '32',
                    ph: '7.5',
                    statusLabel: 'Peringatan',
                    statusType: BadgeType.warning,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(User? user, BuildContext context) {
    return AppHeader(
      title: 'Selamat Datang, ${user?.name}',
      subtitle: '${user?.roleLabel}',
      onNotificationPressed: () {
        AppRoutes.pushNamed(context, AppRoutes.notification);
      },
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

  Widget _buildSummaryPoolConditions() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.85,
      children: [
        DashboardSummaryCard(
          title: 'Jumlah Ikan',
          value: '${_selectedPool?.currentQuantity ?? 0}',
          backgroundColor: AppColors.secondary,
        ),
        const DashboardSummaryCard(
          title: 'pH Kolam',
          value: '7.5',
          icon: Icons.water_drop,
          backgroundColor: AppColors.yellow,
        ),
        const DashboardSummaryCard(
          title: 'Status Alat Pakan',
          value: 'OFF',
          backgroundColor: AppColors.red,
        ),
        const DashboardSummaryCard(
          title: 'Suhu Kolam',
          value: '32°',
          backgroundColor: AppColors.green,
        ),
      ],
    );
  }
}
