import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_date.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_image.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_snackbar.dart';
import 'package:budidaya_lele_mobile/core/utils/app_format.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/presentation/providers/harvest_report_provider.dart';
import 'package:budidaya_lele_mobile/features/pool/presentation/providers/pool_provider.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_status_badge.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final _reportDateCtrl = TextEditingController();
  final _weightAmountCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(poolDetailNotifierProvider.notifier).getPool(widget.poolId);
    });
  }

  @override
  void dispose() {
    _reportDateCtrl.dispose();
    _weightAmountCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
    if (!_formKey.currentState!.validate()) return;

    final quantity = int.parse(_amountCtrl.text);
    final poolDetail = ref.read(poolDetailNotifierProvider).value;
    final endedAt = quantity == poolDetail?.currentQuantity
        ? AppFormat.toApiDateTime(
            DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
          )
        : null;

    await ref
        .read(harvestReportMutationNotifierProvider.notifier)
        .createHarvestReport(
          widget.poolId,
          widget.cycleId,
          AppFormat.toApiDate(_reportDateCtrl.text),
          int.parse(_weightAmountCtrl.text),
          int.parse(_amountCtrl.text),
          _selectedImage!,
          endedAt,
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
    final poolDetailState = ref.watch(poolDetailNotifierProvider);
    final mutationState = ref.watch(harvestReportMutationNotifierProvider);

    ref.listen(poolDetailNotifierProvider, (previous, next) {
      next.whenData((pool) {
        if (pool != null) {
          _amountCtrl.text = pool.currentQuantity.toString();
        }
      });
    });

    return Scaffold(
      appBar: _buildHeader(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: poolDetailState.when(
            loading: () => _buildLoadingState(),
            error: (err, stack) => _buildErrorState(err),
            data: (pool) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPoolDetail(pool),
                const SizedBox(height: 24),
                _buildFormState(mutationState.isLoading),
              ],
            ),
          ),
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
            'Detail Kolam',
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
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: const Center(child: CircularProgressIndicator()),
    );
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
            AppButton(
              label: 'Coba Lagi',
              onPressed: () => ref
                  .read(poolDetailNotifierProvider.notifier)
                  .getPool(widget.poolId),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPoolDetail(PoolDetail? pool) {
    if (pool == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Siklus', style: TextStyle(fontSize: 15)),
            AppStatusBadge(
              label: pool.cycleLabel,
              type: pool.cycle == 'active_cultivation'
                  ? BadgeType.success
                  : BadgeType.danger,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Kategori', style: TextStyle(fontSize: 15)),
            AppStatusBadge(
              label: pool.categoryLabel,
              type: pool.category == 'breeding'
                  ? BadgeType.warning
                  : pool.category == 'growing'
                  ? BadgeType.success
                  : BadgeType.danger,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Jumlah Ikan', style: TextStyle(fontSize: 15)),
            Text(
              '${pool.currentQuantity} Ekor',
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Ambang Batas Normal pH',
              style: TextStyle(fontSize: 15),
            ),
            Text(
              '${pool.acidityNormal.isNotEmpty ? pool.acidityNormal.first : 0} - ${pool.acidityNormal.isNotEmpty ? pool.acidityNormal.last : 0} pH',
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Ambang Batas Normal Suhu',
              style: TextStyle(fontSize: 15),
            ),
            Text(
              '${pool.temperatureNormal.isNotEmpty ? pool.temperatureNormal.first : 0}°C - ${pool.temperatureNormal.isNotEmpty ? pool.temperatureNormal.last : 0}°C',
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormState(bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tambah Laporan Panen',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          AppInputDate(
            autovalidateMode: _autovalidateMode,
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
            lastDate: DateTime.now(),
          ),
          const SizedBox(height: 16),
          AppInputText(
            autovalidateMode: _autovalidateMode,
            label: 'Jumlah Berat Panen (KG)',
            hint: 'Jumlah Berat Panen',
            controller: _weightAmountCtrl,
            type: FieldType.number,
            requiredField: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Jumlah harus diisi';
              }
              final number = int.tryParse(value);
              if (number == null || number <= 0) {
                return 'Jumlah Berat Panen harus berupa angka positif';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppInputText(
            autovalidateMode: _autovalidateMode,
            label: 'Jumlah Panen (Ekor)',
            hint: 'Jumlah Panen',
            controller: _amountCtrl,
            type: FieldType.number,
            requiredField: true,
            readOnly: true,
          ),
          const SizedBox(height: 16),
          AppInputImage(
            autovalidateMode: _autovalidateMode,
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
          AppButton(
            label: 'Submit',
            onPressed: _onSubmit,
            isLoading: isLoading,
          ),
          const SizedBox(height: 16),
          const Text(
            'Perhatian: Laporan yang telah dikirim tidak dapat diubah atau dihapus kembali. Pastikan seluruh data panen sudah sesuai.',
            style: TextStyle(fontSize: 14, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
