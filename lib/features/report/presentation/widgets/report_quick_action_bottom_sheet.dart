import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ReportQuickActionBottomSheet extends StatelessWidget {
  final String type;

  const ReportQuickActionBottomSheet({super.key, required this.type});

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
              child: _buildContent(),
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

  Widget _buildContent() {
    if (type == 'daily') {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuickActionItem(
            icon: Icons.restaurant,
            title: 'Tambah Laporan Pakan',
            iconColor: AppColors.primary,
          ),
          const Divider(height: 1, color: AppColors.gray),
          _buildQuickActionItem(
            icon: Icons.medical_services,
            title: 'Tambah Laporan Vitamin',
            iconColor: AppColors.primary,
          ),
          const Divider(height: 1, color: AppColors.gray),
          _buildQuickActionItem(
            icon: Icons.dangerous,
            title: 'Tambah Laporan Kematian',
            iconColor: AppColors.primary,
          ),
          const Divider(height: 1, color: AppColors.gray),
          _buildQuickActionItem(
            icon: Icons.error_outline,
            title: 'Tambah Laporan Sakit',
            iconColor: AppColors.primary,
          ),
          const Divider(height: 1, color: AppColors.gray),
          _buildQuickActionItem(
            icon: Icons.water_drop,
            title: 'Tambah Laporan Pembersihan Kolam',
            iconColor: AppColors.primary,
          ),
          const Divider(height: 1, color: AppColors.gray),
          _buildQuickActionItem(
            icon: Icons.trending_up,
            title: 'Tambah Laporan Sampling',
            iconColor: AppColors.primary,
          ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuickActionItem(
            icon: Icons.add_circle_outline,
            title: 'Tambah Laporan Tebar Benih',
            iconColor: AppColors.secondary,
          ),
          const Divider(height: 1, color: AppColors.gray),
          _buildQuickActionItem(
            icon: Icons.agriculture,
            title: 'Tambah Laporan Panen',
            iconColor: AppColors.secondary,
          ),
          const Divider(height: 1, color: AppColors.gray),
          _buildQuickActionItem(
            icon: Icons.swap_horiz,
            title: 'Tambah Laporan Pindah Kolam',
            iconColor: AppColors.secondary,
          ),
        ],
      );
    }
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String title,
    required Color iconColor,
  }) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 24),
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
