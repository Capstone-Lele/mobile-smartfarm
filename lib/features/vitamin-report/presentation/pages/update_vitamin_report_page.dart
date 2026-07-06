import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_date.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_dropdown.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_image.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_snackbar.dart';
import 'package:budidaya_lele_mobile/core/utils/app_format.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/presentation/providers/vitamin_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class UpdateVitaminReportPage extends ConsumerStatefulWidget {
  final String reportId;
  final String cycleId;
  final String poolId;
  final String poolName;

  const UpdateVitaminReportPage({
    super.key,
    required this.reportId,
    required this.cycleId,
    required this.poolId,
    required this.poolName,
  });

  @override
  ConsumerState<UpdateVitaminReportPage> createState() =>
      _UpdateVitaminReportPageState();
}

class _UpdateVitaminReportPageState
    extends ConsumerState<UpdateVitaminReportPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final _reportDateCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  XFile? _selectedImage;
  Inventory? _selectedInventory;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(inventoryListNotifierProvider.notifier).getInventories();
      ref
          .read(vitaminReportDetailNotifierProvider.notifier)
          .getVitaminReport(widget.reportId);
    });
  }

  @override
  void dispose() {
    _reportDateCtrl.dispose();
    _quantityCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(vitaminReportMutationNotifierProvider.notifier)
        .updateVitaminReport(
          widget.reportId,
          widget.poolId,
          _selectedInventory!.id,
          AppFormat.toApiDateTime(_reportDateCtrl.text),
          int.parse(_quantityCtrl.text),
          _selectedImage,
        );

    final mutationState = ref.read(vitaminReportMutationNotifierProvider);

    if (mutationState.hasError) {
      AppSnackbar.error(mutationState.error.toString());
    } else {
      AppSnackbar.success('Laporan berhasil diubah');
      AppRoutes.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final inventoryState = ref.watch(inventoryListNotifierProvider);

    return Scaffold(
      appBar: _buildHeader(context),
      body: SafeArea(
        child: inventoryState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: $error', textAlign: TextAlign.center),
              ],
            ),
          ),
          data: (inventories) => _buildFormState(inventories),
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
            'Ubah Laporan Vitamin',
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

  Widget _buildFormState(List<Inventory> inventories) {
    final vitaminInventories = inventories
        .where(
          (inventory) =>
              inventory.category.toLowerCase() == 'vitamin' &&
              inventory.deletedAt == null,
        )
        .toList();

    final reportDetailState = ref.watch(vitaminReportDetailNotifierProvider);
    final mutationState = ref.watch(vitaminReportMutationNotifierProvider);
    final isLoading = mutationState.isLoading;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: reportDetailState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: $error', textAlign: TextAlign.center),
              ],
            ),
          ),
          data: (report) {
            if (report == null) {
              return const Center(child: Text('Data laporan tidak ditemukan'));
            }

            if (_selectedInventory == null && inventories.isNotEmpty) {
              _reportDateCtrl.text = AppFormat.toUiDateTime(report.reportDate);
              _quantityCtrl.text = report.quantity.toString();

              final matchingInventory = vitaminInventories
                  .where((e) => e.id == report.inventoryId)
                  .firstOrNull;

              _selectedInventory =
                  matchingInventory ?? vitaminInventories.first;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppInputDropdown<Inventory>(
                  autovalidateMode: _autovalidateMode,
                  label: 'Nama Produk',
                  hint: 'Pilih Produk Vitamin',
                  items: vitaminInventories,
                  value: _selectedInventory,
                  itemLabel: (item) => item.product,
                  requiredField: true,
                  onChanged: (value) {
                    setState(() {
                      _selectedInventory = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Nama produk harus dipilih';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppInputDate(
                  autovalidateMode: _autovalidateMode,
                  label: 'Tanggal Pemberian Vitamin',
                  hint: 'Tanggal Pemberian Vitamin',
                  type: DateFieldType.dateTime,
                  controller: _reportDateCtrl,
                  requiredField: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tanggal pemberian vitamin harus dipilih';
                    }

                    return null;
                  },
                  lastDate: DateTime.now(),
                ),
                const SizedBox(height: 16),
                AppInputText(
                  autovalidateMode: _autovalidateMode,
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
                  autovalidateMode: _autovalidateMode,
                  label: 'Foto',
                  hint: 'Tambahkan foto pemberian vitamin',
                  requiredField: true,
                  imageUrl: report.image,
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
            );
          },
        ),
      ),
    );
  }
}
