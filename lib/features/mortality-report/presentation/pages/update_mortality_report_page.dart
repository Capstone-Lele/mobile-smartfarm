import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_date.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_image.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateMortalityReportPage extends StatefulWidget {
  final String reportId;
  final String cycleId;
  final String poolId;
  final String poolName;

  const UpdateMortalityReportPage({
    super.key,
    required this.reportId,
    required this.cycleId,
    required this.poolId,
    required this.poolName,
  });

  @override
  State<UpdateMortalityReportPage> createState() =>
      _UpdateMortalityReportPageState();
}

class _UpdateMortalityReportPageState extends State<UpdateMortalityReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _reportDateCtrl = TextEditingController(text: '08-04-2026');
  final _quantityCtrl = TextEditingController(text: '100');
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
            'Ubah Laporan Kematian',
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
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppInputDate(
                label: 'Tanggal Kematian',
                hint: 'Tanggal Kematian',
                type: DateFieldType.date,
                controller: _reportDateCtrl,
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal kematian harus dipilih';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              AppInputText(
                label: 'Jumlah Kematian (ekor)',
                hint: 'Jumlah Kematian',
                controller: _quantityCtrl,
                type: FieldType.number,
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah Kematian harus diisi';
                  }

                  final number = int.tryParse(value);
                  if (number == null || number <= 0) {
                    return 'Jumlah Kematian harus berupa angka positif';
                  }

                  return null;
                },
              ),
              SizedBox(height: 16),
              AppInputImage(
                label: 'Foto',
                hint: 'Tambahkan foto kematian ikan lele',
                requiredField: true,
                imageUrl: 'https://picsum.photos/200',
                onChanged: (image) {
                  setState(() {
                    _selectedImage = image;
                  });
                },
              ),
              SizedBox(height: 24),
              AppButton(label: 'Submit', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
