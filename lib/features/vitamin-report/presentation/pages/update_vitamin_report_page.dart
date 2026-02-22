import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_date.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_dropdown.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_image.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateVitaminReportPage extends StatefulWidget {
  final String reportId;
  final String cycleId;
  final String poolId;
  final String poolName;

  const UpdateVitaminReportPage({
    super.key,
    required this.reportId,
    required this.cycleId,
    required this.poolId,
    required this.poolName,
  });

  @override
  State<UpdateVitaminReportPage> createState() =>
      _UpdateVitaminReportPageState();
}

class _UpdateVitaminReportPageState extends State<UpdateVitaminReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _reportDateCtrl = TextEditingController(text: '08-04-2026 08:00');
  final _quantityCtrl = TextEditingController(text: '100');
  XFile? _selectedImage;

  final List<String> _vitaminProducts = [
    'Vitamin C 1000mg',
    'Multivitamin Lele Premium',
    'Vitamin B Complex',
    'Vitamin D3 + K2',
    'Vitamin E 400IU',
    'Fish Vitamin Booster',
    'Aqua Vitamin Complete',
    'Mineral + Vitamin Mix',
    'Calcium Vitamin',
    'Growth Vitamin Formula',
  ];

  final String _selectedVitaminProduct = 'Vitamin C 1000mg';

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
            'Ubah Laporan Vitamin',
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
              AppInputDropdown<String>(
                label: 'Nama Produk',
                hint: 'Pilih Produk',
                items: _vitaminProducts,
                value: _selectedVitaminProduct,
                itemLabel: (item) => item,
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama produk harus dipilih';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              AppInputDate(
                label: 'Tanggal Pemberian Vitamin',
                hint: 'Tanggal Pemberian Vitamin',
                type: DateFieldType.dateTime,
                controller: _reportDateCtrl,
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal Pemberian vitamin harus dipilih';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
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
              AppInputImage(
                label: 'Foto',
                hint: 'Tambahkan foto sampling',
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
