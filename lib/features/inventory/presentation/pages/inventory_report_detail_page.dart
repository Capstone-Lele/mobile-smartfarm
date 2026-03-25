import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_dialog.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_date.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_dropdown.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_image.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:flutter/material.dart';

class InventoryReportDetailPage extends StatefulWidget {
  const InventoryReportDetailPage({super.key});

  @override
  State<InventoryReportDetailPage> createState() =>
      _InventoryReportDetailPageState();
}

class _InventoryReportDetailPageState extends State<InventoryReportDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _reportDateCtrl = TextEditingController(text: "2024-06-01");
  final _quantityCtrl = TextEditingController(text: "10");
  final _notesCtrl = TextEditingController(text: "Pengajuan Pakan 100 kg");

  final List<String> _inventoryReports = [
    'Pakan Pelet 781-1',
    'Pakan Pelet 781-2',
    'Pakan Pelet 781-3',
    'Pakan Pelet 781-4',
  ];

  final String _selectedInventoryReport = 'Pakan Pelet 781-1';

  @override
  void dispose() {
    _reportDateCtrl.dispose();
    _quantityCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
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
            'Detail Laporan Inventaris',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildFormState() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppInputDropdown(
                label: 'Nama Produk',
                hint: 'Pilh Produk',
                items: _inventoryReports,
                value: _selectedInventoryReport,
                itemLabel: (item) => item,
                requiredField: true,
                readOnly: true,
              ),
              const SizedBox(height: 16),
              AppInputDate(
                label: 'Tanggal Pemakaian Inventaris',
                hint: 'Tanggal Pemakaian Inventaris',
                type: DateFieldType.date,
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
                imageUrl: 'https://picsum.photos/200',
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
              const SizedBox(height: 24),
              AppButton(
                label: 'Ubah',
                onPressed: () {
                  AppRoutes.pushNamed(context, AppRoutes.updateInventoryReport);
                },
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Hapus',
                color: AppColors.red,
                onPressed: () {
                  AppDialog.showConfirmationDialog(
                    context: context,
                    color: AppColors.red,
                    title: 'Hapus Laporan',
                    message: 'Apakah anda yakin ingin menghapus laporan ini?',
                    confirmText: 'Iya',
                    cancelText: 'Tidak',
                    onConfirm: () async {
                      AppRoutes.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
