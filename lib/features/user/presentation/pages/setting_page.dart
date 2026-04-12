import 'package:budidaya_lele_mobile/common/widgets/app_dialog.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_header.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:budidaya_lele_mobile/features/user/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppHeader(
                  title: 'Selamat Datang, ${user?.name}',
                  subtitle: '${user?.roleLabel}',
                  onNotificationPressed: () {
                    AppRoutes.pushNamed(context, AppRoutes.notification);
                  },
                ),
                const SizedBox(height: 20),
                _buildSectionTitle("Pengaturan Utama"),
                _buildMenuGroup([
                  _buildMenuItem(
                    Icons.person_outline,
                    "Ubah Profil",
                    onTap: () {
                      AppRoutes.pushNamed(context, AppRoutes.changeProfile);
                    },
                  ),
                  _buildMenuItem(
                    Icons.lock_outline,
                    "Ubah Password",
                    isLast: true,
                    onTap: () {
                      AppRoutes.pushNamed(context, AppRoutes.changePassword);
                    },
                  ),
                ]),
                const SizedBox(height: 20),
                _buildSectionTitle("Pengaturan Lainnya"),
                _buildMenuGroup([
                  _buildMenuItem(
                    Icons.verified_user_outlined,
                    "Kebijakan Privasi",
                    onTap: () {},
                  ),
                  _buildMenuItem(Icons.help_outline, "Bantuan", onTap: () {}),
                  _buildMenuItem(
                    Icons.sensors,
                    "Status Alat",
                    onTap: () {
                      AppRoutes.pushNamed(context, AppRoutes.statusDevice);
                    },
                  ),
                  if (user?.role == 'pic') ...[
                    _buildMenuItem(
                      Icons.local_parking,
                      "Manajemen Parameter",
                      onTap: () {
                        AppRoutes.pushNamed(context, AppRoutes.parameter);
                      },
                    ),
                  ],
                  _buildMenuItem(
                    Icons.notifications_none,
                    "Riwayat Notifikasi",
                    isLast: true,
                    onTap: () {},
                  ),
                ]),
                const SizedBox(height: 20),
                _buildSectionTitle("Keluar"),
                _buildMenuGroup([
                  _buildMenuItem(
                    Icons.logout,
                    "Logout",
                    isLast: true,
                    showTrailing: false,
                    onTap: () {
                      AppDialog.showConfirmationDialog(
                        context: context,
                        title: "Keluar",
                        message: "Apakah anda yakin ingin keluar?",
                        confirmText: "Keluar",
                        cancelText: "Tidak",
                        onConfirm: () async {
                          // Proses Logout
                          final success = await ref
                              .read(logoutNotifierProvider.notifier)
                              .logout();

                          if (context.mounted && success) {
                            AppRoutes.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.login,
                            );
                          }
                        },
                      );
                    },
                  ),
                ]),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.darkGray,
        ),
      ),
    );
  }

  Widget _buildMenuGroup(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gray),
      ),
      child: Column(children: items),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String label, {
    bool isLast = false,
    bool showTrailing = true,
    Color textColor = Colors.black,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: isLast
          ? const BorderRadius.vertical(bottom: Radius.circular(8))
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(bottom: BorderSide(color: AppColors.gray)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.black),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            if (showTrailing)
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.darkGray,
              ),
          ],
        ),
      ),
    );
  }
}
