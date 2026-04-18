import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_date.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_format.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_detail.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InventoryDetailPage extends ConsumerStatefulWidget {
  final String inventoryId;

  const InventoryDetailPage({super.key, required this.inventoryId});

  @override
  ConsumerState<InventoryDetailPage> createState() =>
      _InventoryDetailPageState();
}

class _InventoryDetailPageState extends ConsumerState<InventoryDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _productNameCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _getReportDetail());
  }

  @override
  void dispose() {
    _productNameCtrl.dispose();
    _quantityCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  Future<void> _getReportDetail() async {
    await ref
        .read(inventoryDetailNotifierProvider.notifier)
        .getInventory(widget.inventoryId);
  }

  @override
  Widget build(BuildContext context) {
    final inventoryAsync = ref.watch(inventoryDetailNotifierProvider);

    return Scaffold(
      appBar: _buildHeader(context),
      body: inventoryAsync.when(
        loading: () => _buildLoadingState(),
        error: (err, stack) => _buildErrorState(err),
        data: (inventory) => _buildFormState(inventory),
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
            'Detail Inventaris',
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
            AppButton(label: 'Coba Lagi', onPressed: () => _getReportDetail()),
          ],
        ),
      ),
    );
  }

  Widget _buildFormState(InventoryDetail? inventory) {
    if (inventory == null) {
      return const Center(child: Text('Inventaris tidak ditemukan'));
    }

    _productNameCtrl.text = inventory.product;
    _quantityCtrl.text = inventory.totalQuantity.toString();
    _dateCtrl.text = AppFormat.toUiDate(inventory.updatedAt);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppInputText(
                label: 'Nama Produk',
                hint: 'Nama Produk',
                controller: _productNameCtrl,
                type: FieldType.text,
                requiredField: true,
                readOnly: true,
              ),
              const SizedBox(height: 16),
              AppInputText(
                label: 'Jumlah (${inventory.unit})',
                hint: 'Jumlah',
                controller: _quantityCtrl,
                type: FieldType.number,
                requiredField: true,
                readOnly: true,
              ),
              const SizedBox(height: 16),
              AppInputDate(
                label: 'Update Terakhir',
                hint: 'Update Terakhir',
                type: DateFieldType.date,
                controller: _dateCtrl,
                requiredField: true,
                readOnly: true,
              ),
              SizedBox(height: 16),
              Text(
                'Hanya administrator yang memiliki izin untuk mengubah atau menghapus inventaris ini.',
                style: TextStyle(fontSize: 15, color: AppColors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
