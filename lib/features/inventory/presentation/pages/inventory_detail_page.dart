import 'package:budidaya_lele_mobile/common/widgets/app_input_date.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_dropdown.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class InventoryDetailPage extends StatefulWidget {
  const InventoryDetailPage({super.key});

  @override
  State<InventoryDetailPage> createState() => _InventoryDetailPageState();
}

class _InventoryDetailPageState extends State<InventoryDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _quantityCtrl = TextEditingController(text: '5');
  final _dateCtrl = TextEditingController(text: '08-04-2026');

  final List<String> _inventory = [
    'Pakan Pelet 781-1',
    'Pakan Pelet 781-2',
    'Pakan Pelet 781-3',
    'Pakan Pelet 781-4',
  ];

  final String _selectedProduct = 'Pakan Pelet 781-1';

  @override
  void dispose() {
    _quantityCtrl.dispose();
    _dateCtrl.dispose();
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
            'Detail Inventaris',
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
              AppInputDropdown<String>(
                label: 'Nama Produk',
                hint: 'Pilih Produk',
                items: _inventory,
                value: _selectedProduct,
                itemLabel: (item) => item,
                requiredField: true,
                readOnly: true,
              ),
              const SizedBox(height: 16),
              AppInputText(
                label: 'Jumlah (Kg)',
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
