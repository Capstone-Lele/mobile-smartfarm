import 'package:budidaya_lele_mobile/common/widgets/app_date_range_filter.dart';
import 'package:budidaya_lele_mobile/core/network/app_socket.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_dropdown.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_loading.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_format.dart';
import 'package:budidaya_lele_mobile/features/dashboard/presentation/providers/iot_provider.dart';
import 'package:budidaya_lele_mobile/features/dashboard/presentation/widgets/pool_condition_chart.dart';
import 'package:budidaya_lele_mobile/features/dashboard/presentation/widgets/pool_condition_detail_list.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/pool/presentation/providers/pool_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
    AppSocket.instance.connect();
    AppSocket.instance.addPoolDataListener(_onPoolData);
    Future.microtask(() async {
      await ref.read(poolListNotifierProvider.notifier).getPools();
      _joinLoadedPools();
      ref.read(iotListNotifierProvider.notifier).setLoading();
    });
  }

  @override
  void dispose() {
    AppSocket.instance.removePoolDataListener(_onPoolData);
    super.dispose();
  }

  /// Joins the Socket.IO room of every pool so the "all pools" list can be
  /// updated in realtime as each node publishes.
  void _joinLoadedPools() {
    final pools = ref.read(poolListNotifierProvider).value ?? [];
    for (final pool in pools) {
      final nodeId = pool.name.replaceAll(RegExp(r'[^0-9]'), '');
      AppSocket.instance.joinPool(nodeId);
    }
  }

  void _onPoolData(Map<String, dynamic> data) {
    if (!mounted) return;
    // Keep the "all pools" list fresh.
    ref.read(iotListNotifierProvider.notifier).upsertSocketData(data);
    // Update the single-pool detail when it matches the current selection.
    if (_selectedPool != null) {
      final nodeId = _selectedPool!.name.replaceAll(RegExp(r'[^0-9]'), '');
      if (data['node_id'].toString() == nodeId) {
        ref.read(iotDetailNotifierProvider.notifier).applySocketData(data);
      }
    }
  }

  void _onPoolChanged(Pool? pool) {
    setState(() {
      _selectedPool = pool;
      _startDate = null;
      _endDate = null;
    });
    ref.invalidate(chartIotsNotifierProvider);
    if (pool != null) {
      final nodeId = pool.name.replaceAll(RegExp(r'[^0-9]'), '');
      AppSocket.instance.joinPool(nodeId);
      ref.read(iotDetailNotifierProvider.notifier).setLoading(int.tryParse(nodeId) ?? 0);
    }
  }

  /// Ambil data chart untuk rentang [start]–[end] sesuai kolam terpilih
  /// (atau semua kolam bila belum memilih).
  void _fetchChart(DateTime start, DateTime end) {
    final nodeId = _selectedPool != null
        ? _selectedPool!.name.replaceAll(RegExp(r'[^0-9]'), '')
        : '0';

    final startStr = DateFormat('dd-MM-yyyy').format(start);
    final endStr = DateFormat('dd-MM-yyyy').format(end);

    ref
        .read(chartIotsNotifierProvider.notifier)
        .getChartIots(
          nodeId,
          AppFormat.toApiDate(startStr),
          AppFormat.toApiDate(endStr),
        );
  }

  void _onDateRangeChanged(DateTime? start, DateTime? end) {
    setState(() {
      _startDate = start;
      _endDate = end;
    });
    if (start != null && end != null) {
      _fetchChart(start, end);
    }
  }

  void _onDateRangeReset() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });
    ref.invalidate(chartIotsNotifierProvider);
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
            await ref.read(poolListNotifierProvider.notifier).getPools();
            _joinLoadedPools();

            if (_selectedPool != null) {
              final nodeId = _selectedPool!.name.replaceAll(RegExp(r'[^0-9]'), '');
              ref.read(iotDetailNotifierProvider.notifier).setLoading(int.tryParse(nodeId) ?? 0);
            } else {
              ref.read(iotListNotifierProvider.notifier).setLoading();
            }

            if (_startDate != null && _endDate != null) {
              _fetchChart(_startDate!, _endDate!);
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter Sensor Kolam',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGray,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPoolSelector(poolsAsync),
                  const SizedBox(height: 12),
                  AppDateRangeFilter(
                    startDate: _startDate,
                    endDate: _endDate,
                    onFilter: _onDateRangeChanged,
                    onReset: _onDateRangeReset,
                  ),
                  const SizedBox(height: 16),
                  PoolConditionChart(startDate: _startDate, endDate: _endDate),
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
                  PoolConditionDetailList(selectedPool: _selectedPool),
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
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Keseluruhan Kondisi Kolam',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 2),
          Text(
            'Status Kolam',
            style: TextStyle(fontSize: 14, color: Colors.grey),
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
        hint: 'Semua Kolam',
        items: pools,
        itemLabel: (pool) => '${pool.name} - ${pool.categoryLabel}',
        value: _selectedPool,
        onChanged: _onPoolChanged,
      ),
    );
  }
}
