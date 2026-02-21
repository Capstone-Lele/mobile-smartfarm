import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_dialog.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_date.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_image.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:flutter/material.dart';

class SamplingReportDetailPage extends StatefulWidget {
  final String reportId;
  final String cycleId;
  final String poolId;
  final String poolName;

  const SamplingReportDetailPage({
    super.key,
    required this.reportId,
    required this.cycleId,
    required this.poolId,
    required this.poolName,
  });

  @override
  State<SamplingReportDetailPage> createState() =>
      _SamplingReportDetailPageState();
}

class _SamplingReportDetailPageState extends State<SamplingReportDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _reportDateCtrl = TextEditingController(text: '08-04-2026 08:00');
  final _quantityCtrl = TextEditingController(text: '100');
  final _averageWeightCtrl = TextEditingController(text: '5.5');

  @override
  void dispose() {
    _reportDateCtrl.dispose();
    _quantityCtrl.dispose();
    _averageWeightCtrl.dispose();
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
            'Detail Laporan Sampling',
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
                label: 'Tanggal Sampling',
                hint: 'Tanggal Sampling',
                type: DateFieldType.dateTime,
                controller: _reportDateCtrl,
                requiredField: true,
                readOnly: true,
              ),
              SizedBox(height: 16),
              AppInputText(
                label: 'Jumlah',
                hint: 'Jumlah',
                controller: _quantityCtrl,
                type: FieldType.number,
                requiredField: true,
                readOnly: true,
              ),
              SizedBox(height: 16),
              AppInputText(
                label: 'Berat Rata-rata',
                hint: 'Berat Rata-rata',
                controller: _averageWeightCtrl,
                type: FieldType.number,
                requiredField: true,
                readOnly: true,
              ),
              SizedBox(height: 16),
              AppInputImage(
                label: 'Foto',
                hint: 'Tambahkan foto sampling',
                requiredField: true,
                readOnly: true,
                imageUrl: 'https://picsum.photos/200',
              ),
              SizedBox(height: 24),
              AppButton(
                label: 'Ubah',
                onPressed: () {
                  AppRoutes.pushNamed(
                    context,
                    AppRoutes.updateSamplingReport,
                    arguments: {
                      'reportId': widget.reportId,
                      'cycleId': widget.cycleId,
                      'poolId': widget.poolId,
                      'poolName': widget.poolName,
                    },
                  );
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
