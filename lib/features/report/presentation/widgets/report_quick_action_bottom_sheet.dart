import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:flutter/material.dart';

class ReportQuickActionBottomSheet extends StatelessWidget {
  final String type;
  final String poolId;
  final String poolName;
  final String cycleId;
  final String poolCategory;
  final bool isCycle;

  const ReportQuickActionBottomSheet({
    super.key,
    required this.type,
    required this.poolId,
    required this.poolName,
    required this.cycleId,
    required this.poolCategory,
    required this.isCycle,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildHeader(context),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Aksi Cepat',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: AppColors.darkGray),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    final isGrowing = poolCategory.contains('growing');
    final isBreeding = poolCategory.contains('breeding');

    if (type == 'daily') {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isCycle) ...[
            _buildQuickActionItem(
              icon: Icons.restaurant,
              title: 'Tambah Laporan Pakan',
              iconColor: AppColors.primary,
              onTap: () {
                Navigator.pop(context);
                AppRoutes.pushNamed(
                  context,
                  AppRoutes.createFeedingReport,
                  arguments: {
                    'poolId': poolId,
                    'poolName': poolName,
                    'cycleId': cycleId,
                  },
                );
              },
            ),
            const Divider(height: 1, color: AppColors.gray),
            _buildQuickActionItem(
              icon: Icons.medical_services,
              title: 'Tambah Laporan Vitamin',
              iconColor: AppColors.primary,
              onTap: () {
                Navigator.pop(context);
                AppRoutes.pushNamed(
                  context,
                  AppRoutes.createVitaminReport,
                  arguments: {
                    'poolId': poolId,
                    'poolName': poolName,
                    'cycleId': cycleId,
                  },
                );
              },
            ),
            const Divider(height: 1, color: AppColors.gray),
            _buildQuickActionItem(
              icon: Icons.dangerous,
              title: 'Tambah Laporan Kematian',
              iconColor: AppColors.primary,
              onTap: () {
                Navigator.pop(context);
                AppRoutes.pushNamed(
                  context,
                  AppRoutes.createMortalityReport,
                  arguments: {
                    'poolId': poolId,
                    'poolName': poolName,
                    'cycleId': cycleId,
                  },
                );
              },
            ),
            if (isGrowing || isBreeding) ...[
              const Divider(height: 1, color: AppColors.gray),
              _buildQuickActionItem(
                icon: Icons.error_outline,
                title: 'Tambah Laporan Sakit',
                iconColor: AppColors.primary,
                onTap: () {
                  Navigator.pop(context);
                  AppRoutes.pushNamed(
                    context,
                    AppRoutes.createSickReport,
                    arguments: {
                      'poolId': poolId,
                      'poolName': poolName,
                      'cycleId': cycleId,
                    },
                  );
                },
              ),
            ],
            const Divider(height: 1, color: AppColors.gray),
          ],
          _buildQuickActionItem(
            icon: Icons.water_drop,
            title: 'Tambah Laporan Pembersihan Kolam',
            iconColor: AppColors.primary,
            onTap: () {
              Navigator.pop(context);
              AppRoutes.pushNamed(
                context,
                AppRoutes.createPoolCleaningReport,
                arguments: {'poolId': poolId, 'poolName': poolName},
              );
            },
          ),
          if (isCycle && (isGrowing || isBreeding)) ...[
            const Divider(height: 1, color: AppColors.gray),
            _buildQuickActionItem(
              icon: Icons.trending_up,
              title: 'Tambah Laporan Sampling',
              iconColor: AppColors.primary,
              onTap: () {
                Navigator.pop(context);
                AppRoutes.pushNamed(
                  context,
                  AppRoutes.createSamplingReport,
                  arguments: {
                    'poolId': poolId,
                    'poolName': poolName,
                    'cycleId': cycleId,
                  },
                );
              },
            ),
          ],
          if (!isCycle) ...[
            const Divider(height: 1, color: AppColors.gray),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Center(
                child: Text(
                  'Siklus tidak aktif, laporan harian lainnya tidak bisa ditambahkan.',
                  style: TextStyle(
                    color: AppColors.red,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isBreeding && !isCycle) ...[
            _buildQuickActionItem(
              icon: Icons.add_circle_outline,
              title: 'Tambah Laporan Tebar Benih',
              iconColor: AppColors.secondary,
              onTap: () {
                Navigator.pop(context);
                AppRoutes.pushNamed(
                  context,
                  AppRoutes.createSeedReport,
                  arguments: {'poolId': poolId, 'poolName': poolName},
                );
              },
            ),
            const Divider(height: 1, color: AppColors.gray),
          ],
          if (isGrowing && isCycle) ...[
            _buildQuickActionItem(
              icon: Icons.agriculture,
              title: 'Tambah Laporan Panen',
              iconColor: AppColors.secondary,
              onTap: () {
                Navigator.pop(context);
                AppRoutes.pushNamed(
                  context,
                  AppRoutes.createHarvestReport,
                  arguments: {
                    'poolId': poolId,
                    'poolName': poolName,
                    'cycleId': cycleId,
                  },
                );
              },
            ),
            const Divider(height: 1, color: AppColors.gray),
          ],
          if (isCycle)
            _buildQuickActionItem(
              icon: Icons.swap_horiz,
              title: 'Tambah Laporan Pindah Kolam',
              iconColor: AppColors.secondary,
              onTap: () {
                Navigator.pop(context);
                AppRoutes.pushNamed(
                  context,
                  AppRoutes.createMovePoolReport,
                  arguments: {
                    'poolId': poolId,
                    'poolName': poolName,
                    'cycleId': cycleId,
                  },
                );
              },
            ),
          if (!isCycle && isGrowing)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'Siklus tidak aktif, silahkan tambahkan laporan pindah kolam ke kolam ini untuk mengaktifkan siklus.',
                  style: TextStyle(
                    color: AppColors.red,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          if (!isCycle && isBreeding && type == 'special')
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 24),
              child: Center(
                child: Text(
                  'Siklus tidak aktif, silahkan tambahkan laporan tebar benih untuk mengaktifkan siklus.',
                  style: TextStyle(
                    color: AppColors.red,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      );
    }
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.darkGray,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
