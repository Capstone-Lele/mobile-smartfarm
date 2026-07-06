import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_snackbar.dart';
import 'package:budidaya_lele_mobile/features/user/domain/entities/user.dart';
import 'package:budidaya_lele_mobile/features/user/presentation/providers/user_provider.dart';
import 'package:budidaya_lele_mobile/features/user/presentation/widgets/profile_photo_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ChangeProfilePage extends ConsumerStatefulWidget {
  const ChangeProfilePage({super.key});

  @override
  ConsumerState<ChangeProfilePage> createState() => _ChangeProfilePageState();
}

class _ChangeProfilePageState extends ConsumerState<ChangeProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  XFile? _profileImage;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _initialData());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _initialData() async {
    await ref.read(userInfoNotifierProvider.notifier).getUserInfo();
  }

  Future<void> _onSubmit() async {
    setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(userMutationNotifierProvider.notifier)
        .changeProfile(_nameCtrl.text, _profileImage);

    final mutationState = ref.read(userMutationNotifierProvider);

    if (mutationState.hasError) {
      AppSnackbar.error(mutationState.error.toString());
    } else {
      AppSnackbar.success('Profil berhasil diubah');
      await ref.read(userInfoNotifierProvider.notifier).getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userInfoNotifierProvider);

    return Scaffold(
      appBar: _buildHeader(context),
      body: user.when(
        loading: () => _buildLoadingState(),
        error: (error, stack) => _buildErrorState(error),
        data: (user) => _buildFormState(user),
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
            'Ubah Profil',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          const Text(
            'Pengaturan',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState(Object error) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $error', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            AppButton(onPressed: () => _initialData(), label: 'Coba Lagi'),
          ],
        ),
      ),
    );
  }

  Widget _buildFormState(User? user) {
    final mutationState = ref.watch(userMutationNotifierProvider);
    final isLoading = mutationState.isLoading;

    if (_nameCtrl.text.isEmpty) {
      _emailCtrl.text = user?.email ?? '';
      _nameCtrl.text = user?.name ?? '';
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: ProfilePhotoInput(
                  initialImageUrl: user?.image ?? '',
                  onChanged: (file) {
                    setState(() {
                      _profileImage = file;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user?.roleLabel ?? 'User',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              AppInputText(
                autovalidateMode: _autovalidateMode,
                label: 'Email Address',
                hint: 'alex@gmail.com',
                controller: _emailCtrl,
                type: FieldType.email,
                requiredField: true,
                readOnly: true,
              ),
              const SizedBox(height: 16),
              AppInputText(
                autovalidateMode: _autovalidateMode,
                label: 'Nama Lengkap',
                hint: 'Nama Lengkap',
                controller: _nameCtrl,
                type: FieldType.text,
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'Ubah',
                onPressed: _onSubmit,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
