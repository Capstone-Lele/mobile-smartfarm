import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_date.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_image.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_snackbar.dart';
import 'package:budidaya_lele_mobile/core/utils/app_format.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/presentation/providers/sampling_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CreateSamplingReportPage extends ConsumerStatefulWidget {
  final String cycleId;
  final String poolId;
  final String poolName;

  const CreateSamplingReportPage({
    super.key,
    required this.cycleId,
    required this.poolId,
    required this.poolName,
  });

  @override
  ConsumerState<CreateSamplingReportPage> createState() =>
      _CreateSamplingReportPageState();
}

class _CreateSamplingReportPageState
    extends ConsumerState<CreateSamplingReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _reportDateCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  final _averageWeightCtrl = TextEditingController();
  XFile? _selectedImage;

  @override
  void dispose() {
    _reportDateCtrl.dispose();
    _quantityCtrl.dispose();
    _averageWeightCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(samplingReportMutationNotifierProvider.notifier)
        .createSamplingReport(
          widget.poolId,
          widget.cycleId,
          AppFormat.toApiDateTime(_reportDateCtrl.text),
          int.parse(_quantityCtrl.text),
          double.parse(_averageWeightCtrl.text),
          _selectedImage!,
        );

    final mutationState = ref.read(samplingReportMutationNotifierProvider);

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
            'Tambah Laporan Sampling',
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
    final mutationState = ref.watch(samplingReportMutationNotifierProvider);
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
                label: 'Tanggal Sampling',
                hint: 'Tanggal Sampling',
                type: DateFieldType.dateTime,
                controller: _reportDateCtrl,
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal sampling harus dipilih';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppInputText(
                label: 'Jumlah',
                hint: 'Jumlah',
                controller: _quantityCtrl,
                type: FieldType.number,
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah harus diisi';
                  }
                  final number = int.tryParse(value);
                  if (number == null || number <= 0) {
                    return 'Jumlah Sampling harus berupa angka positif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppInputText(
                label: 'Rata-rata Berat (gram)',
                hint: 'Rata-rata Berat',
                controller: _averageWeightCtrl,
                type: FieldType.number,
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Rata-rata berat harus diisi';
                  }
                  final number = double.tryParse(value);
                  if (number == null || number <= 0) {
                    return 'Rata-rata berat harus berupa angka positif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppInputImage(
                label: 'Foto',
                hint: 'Tambahkan foto sampling',
                requiredField: true,
                onChanged: (image) {
                  setState(() {
                    _selectedImage = image;
                  });
                },
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'Submit',
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
