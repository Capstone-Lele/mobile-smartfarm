import 'package:budidaya_lele_mobile/common/widgets/app_date_range_filter.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_dropdown.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_loading.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/features/dashboard/presentation/widgets/pool_condition_chart.dart';
import 'package:budidaya_lele_mobile/features/dashboard/presentation/widgets/pool_condition_detail_list.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/pool/presentation/providers/pool_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PoolConditionPage extends ConsumerStatefulWidget {
  const PoolConditionPage({super.key});

  @override
  ConsumerState<PoolConditionPage> createState() => _PoolConditionPageState();
}

class _PoolConditionPageState extends ConsumerState<PoolConditionPage> {
  Pool? _selectedPool;
  DateTime? _startDate;
  DateTime? _endDate;

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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildHeader(context),
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
                  const Text(
                    'Grafik Sensor Kolam',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGray,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPoolSelector(poolsAsync),
                  const SizedBox(height: 16),
                  AppDateRangeFilter(
                    startDate: _startDate,
                    endDate: _endDate,
                    onFilter: (start, end) {
                      setState(() {
                        _startDate = start;
                        _endDate = end;
                      });
                    },
                    onReset: () {
                      setState(() {
                        _startDate = null;
                        _endDate = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const PoolConditionChart(),
                  const SizedBox(height: 16),
                  const Text(
                    'Kondisi Kolam Secara Individu',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGray,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const PoolConditionDetailList(),
                  const SizedBox(height: 16),
                ],
              ),
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
            'Keseluruhan Kondisi Kolam',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            'Status Kolam',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPoolSelector(AsyncValue<List<Pool>> poolsAsync) {
    return poolsAsync.when(
      loading: () => const AppLoading(height: 50, borderRadius: 8),
      error: (error, stack) => AppInputDropdown<Pool>(
        hint: 'Gagal memuat kolam',
        items: const [],
        itemLabel: (pool) => pool.name,
        value: null,
        readOnly: true,
      ),
      data: (pools) => AppInputDropdown<Pool>(
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
    );
  }
}
