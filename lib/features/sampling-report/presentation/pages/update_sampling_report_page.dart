import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_date.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_image.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_snackbar.dart';
import 'package:budidaya_lele_mobile/core/utils/app_format.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/entities/sampling_report.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/presentation/providers/sampling_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class UpdateSamplingReportPage extends ConsumerStatefulWidget {
  final String reportId;
  final String cycleId;
  final String poolId;
  final String poolName;

  const UpdateSamplingReportPage({
    super.key,
    required this.reportId,
    required this.cycleId,
    required this.poolId,
    required this.poolName,
  });

  @override
  ConsumerState<UpdateSamplingReportPage> createState() =>
      _UpdateSamplingReportPageState();
}

class _UpdateSamplingReportPageState
    extends ConsumerState<UpdateSamplingReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _reportDateCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  final _averageWeightCtrl = TextEditingController();
  XFile? _selectedImage;
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialData());
  }

  @override
  void dispose() {
    _reportDateCtrl.dispose();
    _quantityCtrl.dispose();
    _averageWeightCtrl.dispose();
    super.dispose();
  }

  Future<void> _initialData() async {
    try {
      await ref
          .read(samplingReportDetailNotifierProvider.notifier)
          .getSamplingReport(widget.reportId);

      final detailData = ref.read(samplingReportDetailNotifierProvider);
      if (detailData.hasValue && detailData.value != null) {
        final report = detailData.value as SamplingReport;
        _reportDateCtrl.text = AppFormat.toUiDateTime(report.reportDate);
        _quantityCtrl.text = report.quantity.toString();
        _averageWeightCtrl.text = report.averageWeight.toString();
      }
    } catch (e) {
      debugPrint('Error loading initial data: $e');
    } finally {
      if (mounted) {
        setState(() => _isInitialLoading = false);
      }
    }
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(samplingReportMutationNotifierProvider.notifier)
        .updateSamplingReport(
          widget.reportId,
          widget.poolId,
          AppFormat.toApiDateTime(_reportDateCtrl.text),
          int.parse(_quantityCtrl.text),
          double.parse(_averageWeightCtrl.text),
          _selectedImage,
        );

    final mutationState = ref.read(samplingReportMutationNotifierProvider);

    if (mutationState.hasError) {
      AppSnackbar.error(mutationState.error.toString());
    } else {
      AppSnackbar.success('Laporan berhasil diubah');
      AppRoutes.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = ref.watch(samplingReportDetailNotifierProvider);
    final isLoading = _isInitialLoading || detail.isLoading;
    final error = detail.error;

    return Scaffold(
      appBar: _buildHeader(context),
      body: SafeArea(
        child: isLoading
            ? _buildLoadingState()
            : error != null
            ? _buildErrorState(error)
            : _buildFormState(detail.value),
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
            'Ubah Laporan Sampling',
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

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState(Object error) {
    return Center(
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
    );
  }

  Widget _buildFormState(SamplingReport? report) {
    if (report == null) {
      return const Center(child: Text('Laporan tidak ditemukan'));
    }

    final mutationState = ref.watch(samplingReportMutationNotifierProvider);
    final isLoading = mutationState.isLoading;

    return SingleChildScrollView(
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
                  return 'Jumlah harus berupa angka positif';
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
              imageUrl: report.image,
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
          ],
        ),
      ),
    );
  }
}
