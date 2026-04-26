import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_date.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_dropdown.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_image.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_format.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_report_detail.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/providers/inventory_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InventoryReportDetailPage extends ConsumerStatefulWidget {
  final String reportId;

  const InventoryReportDetailPage({super.key, required this.reportId});

  @override
  ConsumerState<InventoryReportDetailPage> createState() =>
      _InventoryReportDetailPageState();
}

class _InventoryReportDetailPageState
    extends ConsumerState<InventoryReportDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _reportDateCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _userCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _getReportDetail());
  }

  @override
  void dispose() {
    _reportDateCtrl.dispose();
    _quantityCtrl.dispose();
    _notesCtrl.dispose();
    _userCtrl.dispose();
    super.dispose();
  }

  Future<void> _getReportDetail() async {
    await ref
        .read(inventoryReportDetailNotifierProvider.notifier)
        .getInventoryReport(widget.reportId);
  }

  @override
  Widget build(BuildContext context) {
    final inventoryReportAsync = ref.watch(
      inventoryReportDetailNotifierProvider,
    );
    return Scaffold(
      appBar: _buildHeader(context),
      body: inventoryReportAsync.when(
        loading: () => _buildLoadingState(),
        error: (err, stack) => _buildErrorState(err),
        data: (report) => _buildFormState(report),
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
            'Detail Laporan Inventaris',
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

  Widget _buildFormState(InventoryReportDetail? report) {
    if (report == null) {
      return const Center(child: Text('Laporan inventaris tidak ditemukan'));
    }

    _reportDateCtrl.text = AppFormat.toUiDateTime(report.reportDate);
    _quantityCtrl.text = report.quantity.toString();
    _notesCtrl.text = report.notes ?? '';
    _userCtrl.text = "Bug";

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppInputDropdown<String>(
                label: 'Nama Produk',
                hint: 'Pilh Produk',
                items: [report.type],
                value: report.type,
                itemLabel: (item) => "item Bug",
                requiredField: true,
                readOnly: true,
              ),
              const SizedBox(height: 16),
              AppInputDate(
                label: 'Tanggal Pemakaian Inventaris',
                hint: 'Tanggal Pemakaian Inventaris',
                type: DateFieldType.dateTime,
                controller: _reportDateCtrl,
                requiredField: true,
                readOnly: true,
              ),
              const SizedBox(height: 16),
              AppInputText(
                label: 'Jumlah',
                hint: 'Jumlah',
                controller: _quantityCtrl,
                type: FieldType.number,
                requiredField: true,
                readOnly: true,
              ),
              const SizedBox(height: 16),
              AppInputImage(
                label: 'Foto',
                hint: 'Tambahkan foto Laporan Inventaris',
                requiredField: true,
                readOnly: true,
                imageUrl: report.image,
              ),
              const SizedBox(height: 16),
              AppInputText(
                label: 'Catatan',
                hint: 'Catatan',
                controller: _notesCtrl,
                type: FieldType.text,
                maxLines: 5,
                minLines: 3,
                requiredField: false,
                readOnly: true,
              ),
              const SizedBox(height: 16),
              AppInputText(
                label: 'Pelapor',
                hint: 'Pelapor',
                controller: _userCtrl,
                type: FieldType.text,
                requiredField: true,
                readOnly: true,
              ),
              const SizedBox(height: 24),
              Text(
                'Laporan inventaris bersifat permanen dan tidak dapat di ubah/hapus',
                style: TextStyle(fontSize: 15, color: AppColors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
