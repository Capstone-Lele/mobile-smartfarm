import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_dropdown.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:flutter/material.dart';

class UpdateInventorySubmissionPage extends StatefulWidget {
  const UpdateInventorySubmissionPage({super.key});

  @override
  State<UpdateInventorySubmissionPage> createState() =>
      _UpdateInventorySubmissionPageState();
}

class _UpdateInventorySubmissionPageState
    extends State<UpdateInventorySubmissionPage> {
  final _formKey = GlobalKey<FormState>();
  final _quantityCtrl = TextEditingController(text: "10");
  final _notesCtrl = TextEditingController(text: "Pengajuan Pakan 100 kg");

  final List<String> _inventorySubmission = [
    'Pakan Pelet 781-1',
    'Pakan Pelet 781-2',
    'Pakan Pelet 781-3',
    'Pakan Pelet 781-4',
  ];

  final String _selectedInventorySubmission = 'Pakan Pelet 781-1';

  final List<String> _status = ['Disetujui', 'Tertunda', 'Ditolak'];

  final String _selectedStatus = 'Disetujui';

  @override
  void dispose() {
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
            'Ubah Pengajuan Inventaris',
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
                items: _inventorySubmission,
                value: _selectedInventorySubmission,
                itemLabel: (item) => item,
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
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
              AppInputDropdown(
                label: 'Status',
                hint: 'Pilh Status',
                items: _status,
                value: _selectedStatus,
                itemLabel: (item) => item,
                requiredField: true,
                readOnly: true,
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
              AppButton(label: 'Submit', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
