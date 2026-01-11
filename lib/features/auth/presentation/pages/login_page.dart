import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_snackbar.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authNotifierProvider.notifier)
          .login(_emailCtrl.text.trim(), _passwordCtrl.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(authNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          AppSnackbar.success('Login berhasil!');
          AppRoutes.pushNamed(context, AppRoutes.dashboard);
        },
        error: (error, _) {
          AppSnackbar.error(error.toString());
        },
      );
    });

    final isLoading = ref.watch(authNotifierProvider).isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: 50,
                      width: 50,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Masuk ke Akun Anda",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Silakan login menggunakan email dan password",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkGray,
                      ),
                    ),
                    Text(
                      "yang sudah terdaftar untuk melanjutkan.",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkGray,
                      ),
                    ),
                    const SizedBox(height: 50),
                    AppInputText(
                      label: 'Email Address',
                      hint: 'alex@gmail.com',
                      controller: _emailCtrl,
                      type: FieldType.email,
                      requiredField: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email harus diisi';
                        }
                        if (!value.contains('@')) {
                          return 'Masukkan format email yang benar';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    AppInputText(
                      label: 'Password',
                      hint: '#Sn123hsn@',
                      controller: _passwordCtrl,
                      type: FieldType.password,
                      requiredField: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password harus diisi';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    isLoading
                        ? const CircularProgressIndicator()
                        : AppButton(label: 'Login', onPressed: _onSubmit),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
