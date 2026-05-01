import 'package:budidaya_lele_mobile/common/widgets/app_loading.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_status_badge.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/entities/iot.dart';
import 'package:budidaya_lele_mobile/features/dashboard/presentation/providers/iot_provider.dart';
import 'package:budidaya_lele_mobile/features/dashboard/presentation/utils/dashboard_utils.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/pool/presentation/providers/pool_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PoolConditionDetailList extends ConsumerWidget {
  final Pool? selectedPool;

  const PoolConditionDetailList({super.key, this.selectedPool});

  ParamStatus _getStatusForIot(Iot iot, List<Pool> allPools) {
    final nodeId = iot.nodeId.toString();

    Pool? matchingPool;
    try {
      matchingPool = allPools.firstWhere(
        (p) => p.name.replaceAll(RegExp(r'[^0-9]'), '') == nodeId,
      );
    } catch (e) {
      return ParamStatus.warning;
    }

    final temp = double.tryParse(iot.temp.toString()) ?? 0.0;
    final ph = double.tryParse(iot.ph.toString()) ?? 0.0;

    final tempStatus = DashboardUtils.getParamStatus(
      temp,
      matchingPool.temperatureMin,
      matchingPool.temperatureNormal,
      matchingPool.temperatureMax,
    );

    final phStatus = DashboardUtils.getParamStatus(
      ph,
      matchingPool.acidityMin,
      matchingPool.acidityNormal,
      matchingPool.acidityMax,
    );

    return DashboardUtils.getOverallStatus(tempStatus, phStatus);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (selectedPool != null) {
      final iotAsync = ref.watch(iotDetailNotifierProvider);
      return iotAsync.when(
        loading: () => const AppLoading(height: 200, borderRadius: 12),
        error: (error, stack) =>
            _buildEmptyCard('Gagal memuat data kondisi kolam'),
        data: (iot) {
          if (iot == null) {
            return _buildEmptyCard('Tidak ada data kondisi kolam');
          }
          return _buildContainer([iot], selectedPool, null);
        },
      );
    }

    final iotsAsync = ref.watch(iotListNotifierProvider);
    final poolsAsync = ref.watch(poolListNotifierProvider);

    return iotsAsync.when(
      loading: () => const AppLoading(height: 200, borderRadius: 12),
      error: (error, stack) =>
          _buildEmptyCard('Gagal memuat data kondisi kolam'),
      data: (iots) {
        if (iots.isEmpty) {
          return _buildEmptyCard('Tidak ada data kondisi kolam');
        }
        return poolsAsync.when(
          loading: () => _buildContainer(iots, null, []),
          error: (e, s) => _buildContainer(iots, null, []),
          data: (pools) => _buildContainer(iots, null, pools),
        );
      },
    );
  }

  Widget _buildContainer(List<Iot> iots, Pool? pool, List<Pool>? allPools) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: AppColors.primary,
            child: const Text(
              'Detail Per Kolam',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          ...List.generate(iots.length, (index) {
            final iot = iots[index];
            final temp = double.tryParse(iot.temp.toString()) ?? 0.0;
            final ph = double.tryParse(iot.ph.toString()) ?? 0.0;

            ParamStatus overallStatus;

            if (pool != null) {
              final tempStatus = DashboardUtils.getParamStatus(
                temp,
                pool.temperatureMin,
                pool.temperatureNormal,
                pool.temperatureMax,
              );
              final phStatus = DashboardUtils.getParamStatus(
                ph,
                pool.acidityMin,
                pool.acidityNormal,
                pool.acidityMax,
              );
              overallStatus = DashboardUtils.getOverallStatus(
                tempStatus,
                phStatus,
              );
            } else {
              if (allPools != null && allPools.isNotEmpty) {
                overallStatus = _getStatusForIot(iot, allPools);
              } else {
                overallStatus = ParamStatus.warning;
              }
            }

            return Column(
              children: [
                if (index > 0) const Divider(height: 1, color: AppColors.gray),
                _buildItem(
                  'Node ${iot.nodeId}',
                  '${temp.toStringAsFixed(1)}°C',
                  ph.toStringAsFixed(1),
                  DashboardUtils.getStatusLabel(overallStatus),
                  DashboardUtils.getBadgeType(overallStatus),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray),
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(color: AppColors.darkGray, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildItem(
    String name,
    String temp,
    String ph,
    String status,
    BadgeType type,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$temp | pH $ph',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGray,
                ),
              ),
              const SizedBox(height: 4),
              AppStatusBadge(label: status, type: type),
            ],
          ),
        ],
      ),
    );
  }
}
