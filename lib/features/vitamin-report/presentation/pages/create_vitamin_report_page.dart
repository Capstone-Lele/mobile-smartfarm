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

class CreateVitaminReportPage extends ConsumerStatefulWidget {
  final String cycleId;
  final String poolId;
  final String poolName;

  const CreateVitaminReportPage({
    super.key,
    required this.cycleId,
    required this.poolId,
    required this.poolName,
  });

  @override
  ConsumerState<CreateVitaminReportPage> createState() =>
      _CreateVitaminReportPageState();
}

class _CreateVitaminReportPageState
    extends ConsumerState<CreateVitaminReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _reportDateCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
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
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(vitaminReportMutationNotifierProvider.notifier)
        .createVitaminReport(
          widget.poolId,
          widget.cycleId,
          _selectedInventory!.id,
          AppFormat.toApiDateTime(_reportDateCtrl.text),
          int.parse(_quantityCtrl.text),
          _selectedImage!,
        );

    final mutationState = ref.read(vitaminReportMutationNotifierProvider);
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
            'Tambah Laporan Vitamin',
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
    final mutationState = ref.watch(vitaminReportMutationNotifierProvider);
    final isLoading = mutationState.isLoading;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: inventoryState.when(
          loading: () => _buildLoadingState(),
          error: (err, stack) => _buildErrorState(err),
          data: (allInventories) {
            final vitaminInventories = allInventories
                .where((inv) => inv.category.toLowerCase() == 'vitamin')
                .toList();

            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppInputDropdown<Inventory>(
                    label: 'Nama Produk',
                    hint: 'Pilih Produk Vitamin',
                    items: vitaminInventories,
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
                  ),
                  const SizedBox(height: 16),
                  AppInputText(
                    label: 'Jumlah Bug (${_selectedInventory?.unit ?? ""})',
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
                    hint: 'Tambahkan foto vitamin yang diberikan',
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
            );
          },
        ),
      ),
    );
  }
}
