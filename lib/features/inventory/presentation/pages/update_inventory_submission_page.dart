import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_dropdown.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_snackbar.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/providers/inventory_submission_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateInventorySubmissionPage extends ConsumerStatefulWidget {
  final String inventorySubmissionId;

  const UpdateInventorySubmissionPage({
    super.key,
    required this.inventorySubmissionId,
  });

  @override
  ConsumerState<UpdateInventorySubmissionPage> createState() =>
      _UpdateInventorySubmissionPageState();
}

class _UpdateInventorySubmissionPageState
    extends ConsumerState<UpdateInventorySubmissionPage> {
  final _formKey = GlobalKey<FormState>();
  final _quantityCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  Inventory? _selectedInventory;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(inventoryListNotifierProvider.notifier).getInventories();
      ref
          .read(inventorySubmissionDetailNotifierProvider.notifier)
          .getInventorySubmission(widget.inventorySubmissionId);
    });
  }

  @override
  void dispose() {
    _quantityCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(inventorySubmissionMutationNotifierProvider.notifier)
        .updateInventorySubmission(
          widget.inventorySubmissionId,
          _selectedInventory!.id,
          int.parse(_quantityCtrl.text),
          'non-grant',
          _notesCtrl.text,
        );

    final mutationState = ref.read(inventorySubmissionMutationNotifierProvider);

    if (mutationState.hasError) {
      AppSnackbar.error(mutationState.error.toString());
    } else {
      AppSnackbar.success('Pengajuan inventaris berhasil diubah');
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
            'Ubah Pengajuan Inventaris',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildFormState(List<Inventory> inventories) {
    final inventorySubmissionDetailState = ref.watch(
      inventorySubmissionDetailNotifierProvider,
    );

    final mutationState = ref.watch(
      inventorySubmissionMutationNotifierProvider,
    );
    final isLoading = mutationState.isLoading;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: inventorySubmissionDetailState.when(
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
          data: (inventorySubmission) {
            if (inventorySubmission == null) {
              return const Center(
                child: Text('Data pengajuan tidak ditemukan'),
              );
            }

            if (_selectedInventory == null && inventories.isNotEmpty) {
              _quantityCtrl.text = inventorySubmission.quantity.toString();
              _notesCtrl.text = inventorySubmission.notes ?? '';

              final matchingInventory = inventories
                  .where((e) => e.id == inventorySubmission.inventoryId)
                  .firstOrNull;

              _selectedInventory = matchingInventory ?? inventories.first;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppInputDropdown(
                  label: 'Nama Produk',
                  hint: 'Pilh Produk',
                  items: inventories,
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
              ],
            );
          },
        ),
      ),
    );
  }
}
