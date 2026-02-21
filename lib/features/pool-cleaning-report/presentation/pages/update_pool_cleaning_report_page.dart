import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_date.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdatePoolCleaningReportPage extends StatefulWidget {
  final String reportId;
  final String poolId;
  final String poolName;

  const UpdatePoolCleaningReportPage({
    super.key,
    required this.reportId,
    required this.poolId,
    required this.poolName,
  });

  @override
  State<UpdatePoolCleaningReportPage> createState() =>
      _UpdatePoolCleaningReportPageState();
}

class _UpdatePoolCleaningReportPageState
    extends State<UpdatePoolCleaningReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _reportDateCtrl = TextEditingController(text: '08-04-2026');
  XFile? _selectedImage;

  @override
  void dispose() {
    _reportDateCtrl.dispose();
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
            'Ubah Laporan Pembersihan',
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
                label: 'Tanggal Pembersihan Kolam',
                hint: 'Tanggal Pembersihan Kolam',
                type: DateFieldType.date,
                controller: _reportDateCtrl,
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal pembersihan kolam harus dipilih';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              AppInputImage(
                label: 'Foto',
                hint: 'Tambahkan foto pembersihan kolam',
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
