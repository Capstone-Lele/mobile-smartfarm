import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_dialog.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_date.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_dropdown.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_image.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_snackbar.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_status_badge.dart';
import 'package:budidaya_lele_mobile/core/utils/app_format.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool_detail.dart';
import 'package:budidaya_lele_mobile/features/pool/presentation/providers/pool_provider.dart';
import 'package:budidaya_lele_mobile/features/move-pool-report/presentation/providers/move_pool_report_provider.dart';
import 'package:budidaya_lele_mobile/features/user/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateMovePoolReportPage extends ConsumerStatefulWidget {
  final String cycleId;
  final String poolId;
  final String poolName;

  const CreateMovePoolReportPage({
    super.key,
    required this.cycleId,
    required this.poolId,
    required this.poolName,
  });

  @override
  ConsumerState<CreateMovePoolReportPage> createState() =>
      _CreateMovePoolReportPageState();
}

class _CreateMovePoolReportPageState
    extends ConsumerState<CreateMovePoolReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _reportDateCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  XFile? _selectedImage;
  Pool? _selectedDestinationPool;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(poolDetailNotifierProvider.notifier).getPool(widget.poolId);
      ref.read(poolListNotifierProvider.notifier).getPools();
    });
  }

  @override
  void dispose() {
    _reportDateCtrl.dispose();
    _quantityCtrl.dispose();
    super.dispose();
  }

  Future<void> _processSubmit() async {
    final quantity = int.parse(_quantityCtrl.text);
    final poolDetail = ref.read(poolDetailNotifierProvider).value;

    final endedAt = quantity == poolDetail?.currentQuantity
        ? AppFormat.toApiDateTime(
            DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
          )
        : null;

    await ref
        .read(movePoolReportMutationNotifierProvider.notifier)
        .createMovePoolReport(
          widget.poolId,
          _selectedDestinationPool!.id,
          widget.cycleId,
          _selectedDestinationPool!.cycleId ?? '',
          AppFormat.toApiDateTime(_reportDateCtrl.text),
          int.parse(_quantityCtrl.text),
          _selectedImage!,
          endedAt,
        );

    final mutationState = ref.read(movePoolReportMutationNotifierProvider);

    if (mutationState.hasError) {
      AppSnackbar.error(mutationState.error.toString());
    } else {
      AppSnackbar.success('Laporan berhasil ditambahkan');
      AppRoutes.pop(context);
    }
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final quantity = int.parse(_quantityCtrl.text);
    final poolDetail = ref.read(poolDetailNotifierProvider).value;

    if (quantity == poolDetail?.currentQuantity) {
      AppDialog.showConfirmationDialog(
        context: context,
        title: 'Akhiri Siklus?',
        message:
            'Siklus akan diakhiri karena semua ikan di kolam dipindahkan. Lanjutkan?',
        confirmText: 'Ya, Lanjutkan',
        cancelText: 'Batal',
        color: Colors.orange,
        onConfirm: () async {
          Navigator.pop(context);
          await _processSubmit();
        },
      );
    } else {
      await _processSubmit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final poolDetailState = ref.watch(poolDetailNotifierProvider);
    final poolListState = ref.watch(poolListNotifierProvider);
    final mutationState = ref.watch(movePoolReportMutationNotifierProvider);

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
                if (user?.role != 'pic') ...[
                  _buildFormState(
                    poolListState,
                    mutationState.isLoading,
                    pool?.category,
                    pool,
                  ),
                ],
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
            Text('Siklus', style: TextStyle(fontSize: 15)),
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
            Text('Jumlah Ikan', style: TextStyle(fontSize: 15)),
            Text(
              '${pool.currentQuantity ?? 0} Ekor',
              style: TextStyle(fontSize: 15),
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

  Widget _buildFormState(
    AsyncValue<List<Pool>> poolListState,
    bool isLoading,
    String? sourcePoolCategory,
    PoolDetail? pool,
  ) {
    List<Pool> filteredPoolList = poolListState.value ?? [];

    if (sourcePoolCategory == 'breeding') {
      filteredPoolList = filteredPoolList
          .where((p) => p.category == 'growing' || p.category == 'breeding')
          .toList();
    } else if (sourcePoolCategory == 'growing') {
      filteredPoolList = filteredPoolList
          .where((p) => p.category == 'growing')
          .toList();
    } else if (sourcePoolCategory == 'quarantine') {
      filteredPoolList = filteredPoolList
          .where((p) => p.category == 'growing' || p.category == 'breeding')
          .toList();
    }

    filteredPoolList = filteredPoolList
        .where((p) => p.id != widget.poolId)
        .toList();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pindah Kolam',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          AppInputDropdown<Pool>(
            label: 'Tujuan Kolam',
            hint: 'Pilih Kolam Tujuan',
            items: filteredPoolList,
            itemLabel: (pool) => '${pool.name} - ${pool.categoryLabel}',
            requiredField: true,
            onChanged: (pool) {
              setState(() {
                _selectedDestinationPool = pool;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Kolam tujuan harus dipilih';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppInputDate(
            label: 'Tanggal Pindah Kolam',
            hint: 'Tanggal Pindah Kolam',
            type: DateFieldType.dateTime,
            controller: _reportDateCtrl,
            requiredField: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Tanggal Pindah Kolam harus dipilih';
              }

              return null;
            },
            lastDate: DateTime.now(),
          ),
          const SizedBox(height: 16),
          AppInputText(
            label: 'Jumlah Ikan Pindah (Ekor)',
            hint: 'Jumlah Ikan Pindah',
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
          AppInputImage(
            label: 'Foto',
            hint: 'Tambahkan foto pindah kolam',
            requiredField: true,
            onChanged: (image) {
              setState(() {
                _selectedImage = image;
              });
            },
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 24),
          AppButton(
            label: 'Pindah',
            onPressed: _onSubmit,
            isLoading: isLoading,
          ),
          const SizedBox(height: 16),
          const Text(
            'Sebelum melanjutkan, pastikan kolam tujuan sudah sesuai. Setelah laporan dipindahkan, data tidak dapat diubah/dihapus untuk menjaga keakuratan riwayat budidaya.',
            style: TextStyle(fontSize: 14, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
