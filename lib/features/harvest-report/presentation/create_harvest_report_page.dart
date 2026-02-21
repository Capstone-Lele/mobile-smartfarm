import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_date.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_image.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateHarvestReportPage extends StatefulWidget {
  final String cycleId;
  final String poolId;
  final String poolName;

  const CreateHarvestReportPage({
    super.key,
    required this.cycleId,
    required this.poolId,
    required this.poolName,
  });

  @override
  State<CreateHarvestReportPage> createState() =>
      _CreateHarvestReportPageState();
}

class _CreateHarvestReportPageState extends State<CreateHarvestReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _reportDateCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  XFile? _selectedImage;

  @override
  void dispose() {
    _reportDateCtrl.dispose();
    _quantityCtrl.dispose();
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
            'Tambah Laporan Panen',
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

  Widget _buildFormState() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppInputDate(
                label: 'Tanggal Panen',
                hint: 'Tanggal Panen',
                type: DateFieldType.date,
                controller: _reportDateCtrl,
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal panen harus dipilih';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              AppInputText(
                label: 'Jumlah Panen (KG)',
                hint: 'Jumlah Panen',
                controller: _quantityCtrl,
                type: FieldType.number,
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah harus diisi';
                  }

                  final number = int.tryParse(value);
                  if (number == null || number <= 0) {
                    return 'Jumlah Panen harus berupa angka positif';
                  }

                  return null;
                },
              ),
              SizedBox(height: 16),
              AppInputImage(
                label: 'Foto',
                hint: 'Tambahkan foto panen',
                requiredField: true,
                onChanged: (image) {
                  setState(() {
                    _selectedImage = image;
                  });
                },
              ),
              SizedBox(height: 24),
              AppButton(label: 'Submit', onPressed: () {}),
              SizedBox(height: 16),
              Text(
                'Perhatian: Laporan yang telah dikirim tidak dapat diubah atau dihapus kembali. Pastikan seluruh data panen sudah sesuai.',
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
