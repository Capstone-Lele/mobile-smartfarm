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
import 'package:budidaya_lele_mobile/features/inventory/presentation/providers/inventory_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CreateInventoryReportPage extends ConsumerStatefulWidget {
  const CreateInventoryReportPage({super.key});

  @override
  ConsumerState<CreateInventoryReportPage> createState() =>
      _CreateInventoryReportPageState();
}

class _CreateInventoryReportPageState
    extends ConsumerState<CreateInventoryReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _reportDateCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  XFile? _selectedImage;
  Inventory? _selectedInventory;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(inventoryListNotifierProvider.notifier).getInventories();
    });
  }

  @override
  void dispose() {
    _reportDateCtrl.dispose();
    _quantityCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(inventoryReportMutationNotifierProvider.notifier)
        .createInventoryReport(
          _selectedInventory!.id,
          AppFormat.toApiDateTime(_reportDateCtrl.text),
          int.parse(_quantityCtrl.text),
          _selectedImage!,
          _notesCtrl.text,
        );

    final mutationState = ref.read(inventoryReportMutationNotifierProvider);

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
            'Tambah Laporan Inventaris',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
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
                  .read(inventoryListNotifierProvider.notifier)
                  .getInventories(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormState() {
    final inventoryState = ref.watch(inventoryListNotifierProvider);
    final mutationState = ref.watch(inventoryReportMutationNotifierProvider);
    final isLoading = mutationState.isLoading;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: inventoryState.when(
          loading: () => _buildLoadingState(),
          error: (err, stack) => _buildErrorState(err),
          data: (allInventories) {
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppInputDropdown(
                    label: 'Nama Produk',
                    hint: 'Pilh Produk',
                    items: allInventories,
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
                    label: 'Tanggal Pemakaian Inventaris',
                    hint: 'Tanggal Pemakaian Inventaris',
                    type: DateFieldType.dateTime,
                    controller: _reportDateCtrl,
                    requiredField: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tanggal pemakaian inventaris harus dipilih';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppInputText(
                    label: 'Jumlah (${_selectedInventory?.unit ?? ""}) ',
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
                  SizedBox(height: 16),
                  AppInputImage(
                    label: 'Foto',
                    hint: 'Tambahkan foto Laporan Inventaris',
                    requiredField: true,
                    onChanged: (image) {
                      setState(() {
                        _selectedImage = image;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  AppInputText(
                    label: 'Catatan',
                    hint: 'Catatan',
                    controller: _notesCtrl,
                    type: FieldType.text,
                    maxLines: 5,
                    minLines: 3,
                    requiredField: false,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Submit',
                    onPressed: _onSubmit,
                    isLoading: isLoading,
                  ),
                  SizedBox(height: 16),
                  const Text(
                    'Perhatian: Laporan yang telah dikirim tidak dapat diubah atau dihapus kembali. Pastikan seluruh data panen sudah sesuai.',
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
