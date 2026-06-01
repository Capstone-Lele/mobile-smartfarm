import 'package:budidaya_lele_mobile/core/constants/app_assets.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/user/domain/entities/user.dart';
import 'package:budidaya_lele_mobile/features/user/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    ref.read(userInfoNotifierProvider.notifier).getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<User?>>(userInfoNotifierProvider, (previous, next) {
      next.when(
        data: (user) {
          if (user != null) {
            AppRoutes.pushReplacementNamed(context, AppRoutes.dashboard);
          } else {
            AppRoutes.pushReplacementNamed(context, AppRoutes.login);
          }
        },
        error: (error, stack) {
          AppRoutes.pushReplacementNamed(context, AppRoutes.login);
        },
        loading: () {},
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppAssets.logo, height: 120, width: 120),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 16),
            const Text(
              "Aplikasi Budidaya Lele",
              style: TextStyle(
                color: AppColors.darkGray,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
