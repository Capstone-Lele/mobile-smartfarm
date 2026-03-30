import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_date.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_dropdown.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_image.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_status_badge.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/pool/presentation/providers/pool_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

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

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _getPoolDetail());
  }

  @override
  void dispose() {
    _reportDateCtrl.dispose();
    _quantityCtrl.dispose();
    super.dispose();
  }

  Future<void> _getPoolDetail() async {
    await ref.read(poolDetailNotifierProvider.notifier).getPool(widget.poolId);
  }

  @override
  Widget build(BuildContext context) {
    final poolDetailState = ref.watch(poolDetailNotifierProvider);

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
                _buildFormState(),
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
          AppButton(label: 'Coba Lagi', onPressed: () => _getPoolDetail()),
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

  Widget _buildFormState() {
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
          AppInputDropdown(
            label: 'Tujuan Kolam',
            hint: 'Tujuan Kolam',
            items: const [],
            itemLabel: (item) => '',
            requiredField: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Kolam tujuan harus dipilih';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppInputDate(
            label: 'Tanggal Pindah Kolam',
            hint: 'Tanggal Pindah Kolam',
            type: DateFieldType.date,
            controller: _reportDateCtrl,
            requiredField: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Tanggal Pindah Kolam harus dipilih';
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
          const SizedBox(height: 24),
          AppButton(label: 'Pindah', onPressed: () {}),
          const SizedBox(height: 16),
          const Text(
            'Sebelum melanjutkan, pastikan kolam tujuan sudah sesuai. Setelah laporan dipindahkan, data tidak dapat diubah atau dihapus untuk menjaga keakuratan riwayat budidaya.',
            style: TextStyle(fontSize: 14, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
