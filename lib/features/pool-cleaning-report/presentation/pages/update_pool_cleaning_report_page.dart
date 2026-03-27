import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_date.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_image.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_snackbar.dart';
import 'package:budidaya_lele_mobile/core/utils/app_format.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/entities/pool_cleaning_report.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/presentation/providers/pool_cleaning_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class UpdatePoolCleaningReportPage extends ConsumerStatefulWidget {
  final String reportId;
  final String poolId;
  final String poolName;

  const UpdatePoolCleaningReportPage({
    super.key,
    required this.reportId,
    required this.poolId,
    required this.poolName,
  });

  @override
  ConsumerState<UpdatePoolCleaningReportPage> createState() =>
      _UpdatePoolCleaningReportPageState();
}

class _UpdatePoolCleaningReportPageState
    extends ConsumerState<UpdatePoolCleaningReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _reportDateCtrl = TextEditingController();
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _initialData());
  }

  @override
  void dispose() {
    _reportDateCtrl.dispose();
    super.dispose();
  }

  Future<void> _initialData() async {
    await ref
        .read(poolCleaningReportDetailNotifierProvider.notifier)
        .getPoolCleaningReport(widget.reportId);
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(poolCleaningReportMutationNotifierProvider.notifier)
        .updatePoolCleaningReport(
          widget.reportId,
          widget.poolId,
          AppFormat.toApiDate(_reportDateCtrl.text),
          _selectedImage,
        );

    final mutationState = ref.read(poolCleaningReportMutationNotifierProvider);

    if (mutationState.hasError) {
      AppSnackbar.error(mutationState.error.toString());
    } else {
      AppSnackbar.success('Laporan berhasil diubah');
      AppRoutes.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = ref.watch(poolCleaningReportDetailNotifierProvider);

    return Scaffold(
      appBar: _buildHeader(context),
      body: SafeArea(
        child: detail.when(
          loading: () => _buildLoadingState(),
          error: (error, stack) => _buildErrorState(error),
          data: (report) => _buildFormState(report),
        ),
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
            'Ubah Laporan Pembersihan',
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

  Widget _buildFormState(PoolCleaningReport? report) {
    if (report == null) {
      return const Center(child: Text('Laporan tidak ditemukan'));
    }

    _reportDateCtrl.text = AppFormat.toUiDateTime(report.reportDate);

    final mutationState = ref.watch(poolCleaningReportMutationNotifierProvider);
    final isLoading = mutationState.isLoading;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppInputDate(
              label: 'Tanggal Pembersihan Kolam',
              hint: 'Tanggal Pembersihan Kolam',
              type: DateFieldType.dateTime,
              controller: _reportDateCtrl,
              requiredField: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tanggal pembersihan kolam harus dipilih';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppInputImage(
              label: 'Foto',
              hint: 'Tambahkan foto pembersihan kolam',
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
