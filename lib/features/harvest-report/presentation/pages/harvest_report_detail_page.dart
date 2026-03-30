import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_date.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:budidaya_lele_mobile/core/utils/app_format.dart';
import 'package:budidaya_lele_mobile/features/user/domain/entities/user.dart';
import 'package:budidaya_lele_mobile/features/user/presentation/providers/user_provider.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/domain/entities/harvest_report.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/presentation/providers/harvest_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HarvestReportDetailPage extends ConsumerStatefulWidget {
  final String reportId;
  final String cycleId;
  final String poolId;
  final String poolName;

  const HarvestReportDetailPage({
    super.key,
    required this.reportId,
    required this.cycleId,
    required this.poolId,
    required this.poolName,
  });

  @override
  ConsumerState<HarvestReportDetailPage> createState() =>
      _HarvestReportDetailPageState();
}

class _HarvestReportDetailPageState
    extends ConsumerState<HarvestReportDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _reportDateCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _userCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _getReportDetail());
  }

  @override
  void dispose() {
    _reportDateCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _getReportDetail() async {
    await ref
        .read(harvestReportDetailNotifierProvider.notifier)
        .getHarvestReport(widget.reportId);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final reportAsync = ref.watch(harvestReportDetailNotifierProvider);

    return Scaffold(
      appBar: _buildHeader(context),
      body: reportAsync.when(
        loading: () => _buildLoadingState(),
        error: (err, stack) => _buildErrorState(err),
        data: (report) => _buildFormState(report, user),
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
            'Detail Laporan Panen',
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

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState(Object error) {
    return Center(
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
    );
  }

  Widget _buildFormState(HarvestReport? report, User? user) {
    if (report == null) {
      return const Center(child: Text('Laporan tidak ditemukan'));
    }

    _reportDateCtrl.text = AppFormat.toUiDate(report.date);
    _amountCtrl.text = report.amount.toString();
    _userCtrl.text = report.user.toString();

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
                readOnly: true,
              ),
              const SizedBox(height: 16),
              AppInputText(
                label: 'Jumlah Panen (KG)',
                hint: 'Jumlah Panen',
                controller: _amountCtrl,
                type: FieldType.number,
                requiredField: true,
                readOnly: true,
              ),
              if (user?.role == 'pic') ...[
                const SizedBox(height: 16),
                AppInputText(
                  label: 'Petugas',
                  hint: 'Petugas',
                  controller: _userCtrl,
                  type: FieldType.text,
                  requiredField: true,
                  readOnly: true,
                ),
              ],
              const SizedBox(height: 16),
              const Text(
                'Catatan: Laporan ini tidak dapat diubah atau dihapus kembali.',
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
