import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_date.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_dropdown.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_image.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_snackbar.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_status_badge.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_format.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/pool/presentation/providers/pool_provider.dart';
import 'package:budidaya_lele_mobile/features/sick-report/presentation/providers/sick_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CreateSickReportPage extends ConsumerStatefulWidget {
  final String cycleId;
  final String poolId;
  final String poolName;

  const CreateSickReportPage({
    super.key,
    required this.cycleId,
    required this.poolId,
    required this.poolName,
  });

  @override
  ConsumerState<CreateSickReportPage> createState() =>
      _CreateSickReportPageState();
}

class _CreateSickReportPageState extends ConsumerState<CreateSickReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _reportDateCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  XFile? _selectedImage;
  Pool? _selectedQuarantinePool;

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

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(sickReportMutationNotifierProvider.notifier)
        .createSickReport(
          widget.poolId,
          widget.cycleId,
          _selectedQuarantinePool!.cycleId!,
          AppFormat.toApiDateTime(_reportDateCtrl.text),
          int.parse(_quantityCtrl.text),
          _selectedImage!,
        );

    final mutationState = ref.read(sickReportMutationNotifierProvider);
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
    final poolListState = ref.watch(poolListNotifierProvider);
    final mutationState = ref.watch(sickReportMutationNotifierProvider);

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
                _buildFormState(poolListState, mutationState.isLoading),
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
            'Laporan Ikan Sakit',
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
          AppButton(
            label: 'Coba Lagi',
            onPressed: () => ref
                .read(poolDetailNotifierProvider.notifier)
                .getPool(widget.poolId),
          ),
        ],
      ),
    );
  }

  Widget _buildPoolDetail(Pool? pool) {
    if (pool == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detail Kolam',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Jumlah Ikan', style: TextStyle(fontSize: 15)),
            Text('100 Ekor Bug', style: TextStyle(fontSize: 15)),
          ],
        ),
        const SizedBox(height: 12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('pH Sekarang', style: TextStyle(fontSize: 15)),
            Text('7.0 pH Bug', style: TextStyle(fontSize: 15)),
          ],
        ),
        const SizedBox(height: 12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Suhu Sekarang', style: TextStyle(fontSize: 15)),
            Text('28 °C Bug', style: TextStyle(fontSize: 15)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Ambang Batas pH', style: TextStyle(fontSize: 15)),
            Text(
              '${pool.acidityMin} - ${pool.acidityMax} pH',
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Ambang Batas Suhu', style: TextStyle(fontSize: 15)),
            Text(
              '${pool.temperatureMin}°C - ${pool.temperatureMax}°C',
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormState(AsyncValue<List<Pool>> poolListState, bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pindah Kolam Karantine',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          AppInputDropdown<Pool>(
            label: 'Kolam Karantina',
            hint: 'Pilih Kolam Karantina',
            items: poolListState.value ?? [],
            itemLabel: (pool) => '${pool.name} - ${pool.categoryLabel}',
            requiredField: true,
            onChanged: (pool) {
              setState(() {
                _selectedQuarantinePool = pool;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Kolam karantina harus dipilih';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppInputDate(
            label: 'Tanggal Ikan Sakit',
            hint: 'Tanggal Ikan Sakit',
            type: DateFieldType.dateTime,
            controller: _reportDateCtrl,
            requiredField: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Tanggal harus dipilih';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppInputText(
            label: 'Jumlah Ikan Sakit',
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
          AppInputImage(
            label: 'Foto',
            hint: 'Tambahkan foto ikan sakit',
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
              : AppButton(label: 'Pindah', onPressed: _onSubmit),
          const SizedBox(height: 16),
          const Text(
            'Segera pindahkan ikan ke kolam karantina untuk mencegah penularan.',
            style: TextStyle(fontSize: 14, color: AppColors.red),
          ),
        ],
      ),
    );
  }
}
