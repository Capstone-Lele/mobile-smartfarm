import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_date.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_image.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_snackbar.dart';
import 'package:budidaya_lele_mobile/core/utils/app_format.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/auth/presentation/providers/user_provider.dart';
import 'package:budidaya_lele_mobile/features/seed-report/presentation/providers/seed_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CreateSeedReportPage extends ConsumerStatefulWidget {
  final String poolId;
  final String poolName;

  const CreateSeedReportPage({
    super.key,
    required this.poolId,
    required this.poolName,
  });

  @override
  ConsumerState<CreateSeedReportPage> createState() =>
      _CreateSeedReportPageState();
}

class _CreateSeedReportPageState extends ConsumerState<CreateSeedReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _reportDateCtrl = TextEditingController();
  final _initialQuantityCtrl = TextEditingController();
  final _currentQuantityCtrl = TextEditingController();
  final _initialAverageWeightCtrl = TextEditingController();
  XFile? _selectedImage;

  @override
  void dispose() {
    _reportDateCtrl.dispose();
    _initialQuantityCtrl.dispose();
    _currentQuantityCtrl.dispose();
    _initialAverageWeightCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(userProvider);

    await ref
        .read(seedReportMutationNotifierProvider.notifier)
        .createSeedReport(
          widget.poolId,
          user?.id ?? '',
          AppFormat.toApiDateTime(_reportDateCtrl.text),
          int.parse(_initialQuantityCtrl.text),
          int.parse(_currentQuantityCtrl.text),
          double.parse(_initialAverageWeightCtrl.text),
          _selectedImage!,
        );

    final mutationState = ref.read(seedReportMutationNotifierProvider);

    if (mutationState.hasError) {
      AppSnackbar.error(mutationState.error.toString());
    } else {
      AppSnackbar.success('Laporan berhasil ditambahkan');
      AppRoutes.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildHeader(context), body: _buildFormState());
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
            'Tambah Laporan Tebar Benih',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            'Data ${widget.poolName}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildFormState() {
    final mutationState = ref.watch(seedReportMutationNotifierProvider);
    final isLoading = mutationState.isLoading;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppInputDate(
                label: 'Tanggal Tebar Benih',
                hint: 'Tanggal Tebar Benih',
                type: DateFieldType.dateTime,
                controller: _reportDateCtrl,
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal tebar benih harus dipilih';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppInputText(
                label: 'Jumlah Benih Awal (ekor)',
                hint: 'Jumlah Benih Awal',
                controller: _initialQuantityCtrl,
                type: FieldType.number,
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah benih awal harus diisi';
                  }
                  final number = int.tryParse(value);
                  if (number == null || number <= 0) {
                    return 'Jumlah benih awal harus berupa angka positif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppInputText(
                label: 'Jumlah Lele Saat ini (ekor)',
                hint: 'Jumlah Lele Saat ini',
                controller: _currentQuantityCtrl,
                type: FieldType.number,
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah lele saat ini harus diisi';
                  }
                  final number = int.tryParse(value);
                  if (number == null || number <= 0) {
                    return 'Jumlah lele saat ini harus berupa angka positif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppInputText(
                label: 'Bobot Rata-rata Awal (gram)',
                hint: 'Bobot Rata-rata Awal',
                controller: _initialAverageWeightCtrl,
                type: FieldType.number,
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bobot Rata-rata Awal harus diisi';
                  }
                  final number = double.tryParse(value);
                  if (number == null || number <= 0) {
                    return 'Bobot Rata-rata Awal harus berupa angka positif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppInputImage(
                label: 'Foto',
                hint: 'Tambahkan foto tebar benih',
                requiredField: true,
                onChanged: (image) {
                  setState(() {
                    _selectedImage = image;
                  });
                },
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AppButton(label: 'Submit', onPressed: _onSubmit),
              const SizedBox(height: 16),
              const Text(
                'Perhatian: Laporan yang telah dikirim tidak dapat diubah kembali. Pastikan seluruh data tebar benih sudah sesuai.',
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
