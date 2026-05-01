import 'package:budidaya_lele_mobile/common/widgets/app_header.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_dropdown.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_loading.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/dashboard/presentation/widgets/dashboard_summary_card.dart';
import 'package:budidaya_lele_mobile/features/dashboard/presentation/widgets/dashboard_pool_status_card.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/entities/iot.dart';
import 'package:budidaya_lele_mobile/features/dashboard/presentation/providers/iot_provider.dart';
import 'package:budidaya_lele_mobile/features/pool/presentation/providers/pool_provider.dart';
import 'package:budidaya_lele_mobile/features/user/domain/entities/user.dart';
import 'package:budidaya_lele_mobile/features/user/presentation/providers/user_provider.dart';
import 'package:budidaya_lele_mobile/features/dashboard/presentation/utils/dashboard_utils.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  Pool? _selectedPool;
  Timer? _iotTimer;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(poolListNotifierProvider.notifier).getPools();
    });
  }

  @override
  void dispose() {
    _iotTimer?.cancel();
    super.dispose();
  }

  void _startIotTimer(String nodeId) {
    _iotTimer?.cancel();
    _iotTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      if (mounted && ModalRoute.of(context)?.isCurrent == true) {
        ref
            .read(iotDetailNotifierProvider.notifier)
            .getIot(nodeId, showLoading: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final poolsAsync = ref.watch(poolListNotifierProvider);
    final iotAsync = ref.watch(iotDetailNotifierProvider);

    // Initial selected pool setup
    poolsAsync.whenData((pools) {
      if (pools.isNotEmpty && _selectedPool == null) {
        Future.microtask(() {
          if (mounted) {
            setState(() {
              _selectedPool = pools.first;
            });
            final nodeId = pools.first.name.replaceAll(RegExp(r'[^0-9]'), '');
            ref.read(iotDetailNotifierProvider.notifier).getIot(nodeId);
            _startIotTimer(nodeId);
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(poolListNotifierProvider.notifier).getPools();
            if (_selectedPool != null) {
              final nodeId = _selectedPool!.name.replaceAll(
                RegExp(r'[^0-9]'),
                '',
              );
              await ref.read(iotDetailNotifierProvider.notifier).getIot(nodeId);
            }
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kondisi ${_selectedPool?.name ?? ""}',
                        style: const TextStyle(
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
                          'Lihat Semua Kolam',
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
                  iotAsync.when(
                    loading: () =>
                        const AppLoading(height: 100, borderRadius: 12),
                    error: (error, stack) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.gray),
                        ),
                        child: Center(
                          child: Text(
                            "Gagal memuat data kondisi kolam",
                            style: const TextStyle(
                              color: AppColors.darkGray,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    },
                    data: (iot) {
                      final tempValue = iot?.temp ?? 0.0;
                      final phValue = iot?.ph ?? 0.0;

                      ParamStatus tempStatus = ParamStatus.danger;
                      ParamStatus phStatus = ParamStatus.danger;

                      if (_selectedPool != null) {
                        tempStatus = DashboardUtils.getParamStatus(
                          tempValue,
                          _selectedPool!.temperatureMin,
                          _selectedPool!.temperatureNormal,
                          _selectedPool!.temperatureMax,
                        );
                        phStatus = DashboardUtils.getParamStatus(
                          phValue,
                          _selectedPool!.acidityMin,
                          _selectedPool!.acidityNormal,
                          _selectedPool!.acidityMax,
                        );
                      }

                      final overallStatus = DashboardUtils.getOverallStatus(
                        tempStatus,
                        phStatus,
                      );

                      return DashboardPoolStatusCard(
                        poolName: _selectedPool?.name ?? 'Kolam 1',
                        temperature: '$tempValue',
                        ph: '$phValue',
                        statusLabel: DashboardUtils.getStatusLabel(
                          overallStatus,
                        ),
                        statusType: DashboardUtils.getBadgeType(overallStatus),
                      );
                    },
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
            'Pilih Kolam',
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
            'Pilih Kolam',
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
            'Pilih Kolam',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 8),
          AppInputDropdown<Pool>(
            hint: 'Pilih Kolam',
            items: pools,
            itemLabel: (pool) => '${pool.name} - ${pool.categoryLabel}',
            value: _selectedPool,
            onChanged: (pool) {
              if (pool != null) {
                setState(() {
                  _selectedPool = pool;
                });
                final nodeId = pool.name.replaceAll(RegExp(r'[^0-9]'), '');
                ref.read(iotDetailNotifierProvider.notifier).getIot(nodeId);
                _startIotTimer(nodeId);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryPoolConditions() {
    final iotAsync = ref.watch(iotDetailNotifierProvider);

    return iotAsync.when(
      loading: () => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85,
        children: List.generate(
          4,
          (index) => const AppLoading(height: 150, borderRadius: 12),
        ),
      ),
      error: (error, stack) => _buildSummaryCards(null),
      data: (iot) => _buildSummaryCards(iot),
    );
  }

  Widget _buildSummaryCards(Iot? iot) {
    final tempValue = iot?.temp ?? 0.0;
    final phValue = iot?.ph ?? 0.0;

    ParamStatus tempStatus = ParamStatus.danger;
    ParamStatus phStatus = ParamStatus.danger;

    if (_selectedPool != null && iot != null) {
      tempStatus = DashboardUtils.getParamStatus(
        tempValue,
        _selectedPool!.temperatureMin,
        _selectedPool!.temperatureNormal,
        _selectedPool!.temperatureMax,
      );
      phStatus = DashboardUtils.getParamStatus(
        phValue,
        _selectedPool!.acidityMin,
        _selectedPool!.acidityNormal,
        _selectedPool!.acidityMax,
      );
    }

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
        DashboardSummaryCard(
          title: 'pH Kolam',
          value: '${iot?.ph ?? 0}',
          icon: Icons.water_drop,
          backgroundColor: iot == null
              ? AppColors.red
              : DashboardUtils.getStatusColor(phStatus),
        ),
        const DashboardSummaryCard(
          title: 'Status Alat Pakan',
          value: 'OFF',
          backgroundColor: AppColors.red,
        ),
        DashboardSummaryCard(
          title: 'Suhu Kolam',
          value: '${iot?.temp ?? 0}°',
          backgroundColor: iot == null
              ? AppColors.red
              : DashboardUtils.getStatusColor(tempStatus),
        ),
      ],
    );
  }
}
