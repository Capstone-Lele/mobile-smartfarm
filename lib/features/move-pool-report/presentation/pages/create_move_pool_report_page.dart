import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_date.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_dropdown.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_image.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateMovePoolReportPage extends StatefulWidget {
  final String cycleId;
  final String poolId;
  final String poolName;

  const CreateMovePoolReportPage({
    super.key,
    required this.cycleId,
    required this.poolId,
    required this.poolName,
  });

  @override
  State<CreateMovePoolReportPage> createState() =>
      _CreateMovePoolReportPageState();
}

class _CreateMovePoolReportPageState extends State<CreateMovePoolReportPage> {
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
    return Scaffold(
      appBar: _buildHeader(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPoolDetail(),
              SizedBox(height: 12),
              _buildFormState(),
            ],
          ),
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
            'Detail Kolam',
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

  Widget _buildPoolDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detail Kolam',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Kategori', style: TextStyle(fontSize: 15)),
            AppStatusBadge(label: 'Pembenihan', type: BadgeType.warning),
          ],
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Jumlah Ikan', style: TextStyle(fontSize: 15)),
            Text('1500 Ekor', style: TextStyle(fontSize: 15)),
          ],
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('pH Sekarang', style: TextStyle(fontSize: 15)),
            Text('7 pH', style: TextStyle(fontSize: 15)),
          ],
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Suhu Sekarang', style: TextStyle(fontSize: 15)),
            Text('30°C', style: TextStyle(fontSize: 15)),
          ],
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ambang Batas pH', style: TextStyle(fontSize: 15)),
            Text('6.5 - 8.5 pH', style: TextStyle(fontSize: 15)),
          ],
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ambang Batas Suhu', style: TextStyle(fontSize: 15)),
            Text('26°C - 30°C', style: TextStyle(fontSize: 15)),
          ],
        ),
      ],
    );
  }

  Widget _buildFormState() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pindah Kolam',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          AppInputDropdown(
            label: 'Tujuan Kolam',
            hint: 'Tujuan Kolam',
            items: [],
            itemLabel: (item) => item['name'] as String,
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
            label: 'Tanggal Pindah Kolam',
            hint: 'Tanggal Pindah Kolam',
            type: DateFieldType.date,
            controller: _reportDateCtrl,
            requiredField: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Tanggal Pindah Kolam harus dipilih';
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
            hint: 'Tambahkan foto pindah kolam',
            requiredField: true,
            onChanged: (image) {
              setState(() {
                _selectedImage = image;
              });
            },
          ),
          SizedBox(height: 24),
          AppButton(label: 'Pindah', onPressed: () {}),
          SizedBox(height: 16),
          Text(
            'Sebelum melanjutkan, pastikan kolam tujuan sudah sesuai. Setelah laporan dipindahkan, data tidak dapat diubah atau dihapus untuk menjaga keakuratan riwayat budidaya.',
            style: TextStyle(fontSize: 14, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
