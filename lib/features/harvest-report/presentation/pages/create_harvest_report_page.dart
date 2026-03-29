import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_date.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_image.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_snackbar.dart';
import 'package:budidaya_lele_mobile/core/utils/app_format.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/presentation/providers/harvest_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CreateHarvestReportPage extends ConsumerStatefulWidget {
  final String cycleId;
  final String poolId;
  final String poolName;

  const CreateHarvestReportPage({
    super.key,
    required this.cycleId,
    required this.poolId,
    required this.poolName,
  });

  @override
  ConsumerState<CreateHarvestReportPage> createState() =>
      _CreateHarvestReportPageState();
}

class _CreateHarvestReportPageState
    extends ConsumerState<CreateHarvestReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _reportDateCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  XFile? _selectedImage;

  @override
  void dispose() {
    _reportDateCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    
    await ref
        .read(harvestReportMutationNotifierProvider.notifier)
        .createHarvestReport(
          widget.poolId,
          widget.cycleId,
          AppFormat.toApiDate(_reportDateCtrl.text),
          int.parse(_amountCtrl.text),
          _selectedImage!,
        );

    final mutationState = ref.read(harvestReportMutationNotifierProvider);

    if (mutationState.hasError) {
      AppSnackbar.error(mutationState.error.toString());
    } else {
      AppSnackbar.success('Laporan berhasil ditambahkan');
      AppRoutes.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildHeader(context),
      body: _buildFormState(),
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
            'Tambah Laporan Panen',
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
    final mutationState = ref.watch(harvestReportMutationNotifierProvider);
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
                label: 'Tanggal Panen',
                hint: 'Tanggal Panen',
                type: DateFieldType.date,
                controller: _reportDateCtrl,
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal panen harus dipilih';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppInputText(
                label: 'Jumlah Panen (KG)',
                hint: 'Jumlah Panen',
                controller: _amountCtrl,
                type: FieldType.number,
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah harus diisi';
                  }
                  final number = int.tryParse(value);
                  if (number == null || number <= 0) {
                    return 'Jumlah Panen harus berupa angka positif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppInputImage(
                label: 'Foto',
                hint: 'Tambahkan foto panen',
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
                'Perhatian: Laporan yang telah dikirim tidak dapat diubah atau dihapus kembali. Pastikan seluruh data panen sudah sesuai.',
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
