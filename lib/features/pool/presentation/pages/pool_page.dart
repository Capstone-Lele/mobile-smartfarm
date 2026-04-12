import 'package:budidaya_lele_mobile/common/widgets/app_hint_board.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_status_badge.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_loading.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/user/presentation/providers/user_provider.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/pool/presentation/providers/pool_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PoolPage extends ConsumerStatefulWidget {
  const PoolPage({super.key});

  @override
  ConsumerState<PoolPage> createState() => _PoolPageState();
}

class _PoolPageState extends ConsumerState<PoolPage> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(poolListNotifierProvider.notifier).getPools();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final poolState = ref.watch(poolListNotifierProvider);

    return Scaffold(
      appBar: _buildHeader(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(poolListNotifierProvider.notifier).getPools();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                AppHintBoard(
                  title: '📌 Petunjuk Kolam',
                  desc: '• Ketuk kolam untuk lihat detailnya.',
                ),
                const SizedBox(height: 16),
                if (user?.role == 'pic') ...[
                  poolState.when(
                    loading: () => _buildSummaryCardsLoading(),
                    error: (error, stack) => Center(
                      child: Text(
                        error.toString(),
                        style: const TextStyle(color: AppColors.red),
                      ),
                    ),
                    data: (pools) => _buildSummaryCards(pools),
                  ),
                  const SizedBox(height: 16),
                ],
                AppInputText(
                  hint: 'Masukkan nama kolam',
                  controller: _searchCtrl,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  prefix: const Icon(Icons.search, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                poolState.when(
                  loading: () => ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        AppLoading(height: 100, borderRadius: 8),
                  ),
                  error: (error, stack) => Center(
                    child: Text(
                      error.toString(),
                      style: const TextStyle(color: AppColors.red),
                    ),
                  ),
                  data: (pools) {
                    final filteredData = pools.where((pool) {
                      return pool.name.toLowerCase().contains(_searchQuery);
                    }).toList();

                    if (filteredData.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Text(
                            'Tidak ada kolam yang ditemukan.',
                            style: TextStyle(color: AppColors.darkGray),
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredData.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final pool = filteredData[index];
                        return _buildPoolItem(pool);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildHeader(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daftar Kolam',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildPoolItem(Pool pool) {
    return GestureDetector(
      onTap: () {
        AppRoutes.pushNamed(
          context,
          AppRoutes.createMovePoolReport,
          arguments: {
            'poolId': pool.id,
            'poolName': pool.name,
            'cycleId': pool.cycleId ?? '',
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.darkGray),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.gray,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.image_not_supported,
                    color: AppColors.darkGray,
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
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          AppStatusBadge(
                            label: pool.categoryLabel,
                            type: pool.category == 'breeding'
                                ? BadgeType.warning
                                : pool.category == 'growing'
                                ? BadgeType.success
                                : BadgeType.danger,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Jumlah Ikan Saat ini ${pool.currentQuantity ?? '0'} Ekor',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCardsLoading() {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(child: AppLoading(height: 100, borderRadius: 12)),
          const SizedBox(width: 8),
          Expanded(child: AppLoading(height: 100, borderRadius: 12)),
          const SizedBox(width: 8),
          Expanded(child: AppLoading(height: 100, borderRadius: 12)),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(List<Pool> pools) {
    final breedingCount = pools.where((p) => p.category == 'breeding').length;
    final growingCount = pools.where((p) => p.category == 'growing').length;
    final quarantineCount = pools
        .where((p) => p.category == 'quarantine')
        .length;

    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              breedingCount.toString(),
              'Kolam Pembenihan',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildSummaryCard(
              growingCount.toString(),
              'Kolam Pembesaran',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildSummaryCard(
              quarantineCount.toString(),
              'Kolam Karantina',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String count, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkGray),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                count,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.water_drop, color: Colors.black, size: 24),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
