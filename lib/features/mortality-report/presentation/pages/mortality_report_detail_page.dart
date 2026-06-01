import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_dialog.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_hint_board.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_date.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_image.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_snackbar.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_format.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/entities/mortality_report_detail.dart';
import 'package:budidaya_lele_mobile/features/user/domain/entities/user.dart';
import 'package:budidaya_lele_mobile/features/user/presentation/providers/user_provider.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/presentation/providers/mortality_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MortalityReportDetailPage extends ConsumerStatefulWidget {
  final String reportId;
  final String cycleId;
  final String poolId;
  final String poolName;

  const MortalityReportDetailPage({
    super.key,
    required this.reportId,
    required this.cycleId,
    required this.poolId,
    required this.poolName,
  });

  @override
  ConsumerState<MortalityReportDetailPage> createState() =>
      _MortalityReportDetailPageState();
}

class _MortalityReportDetailPageState
    extends ConsumerState<MortalityReportDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _reportDateCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  final _userCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _getReportDetail());
  }

  @override
  void dispose() {
    _reportDateCtrl.dispose();
    _quantityCtrl.dispose();
    _userCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _getReportDetail() async {
    await ref
        .read(mortalityReportDetailNotifierProvider.notifier)
        .getMortalityReport(widget.reportId);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final reportAsync = ref.watch(mortalityReportDetailNotifierProvider);

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
            'Detail Laporan Kematian',
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
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
      ),
    );
  }

  Widget _buildFormState(MortalityReportDetail? report, User? user) {
    if (report == null) {
      return const Center(child: Text('Laporan tidak ditemukan'));
    }

    _reportDateCtrl.text = AppFormat.toUiDate(report.reportDate);
    _quantityCtrl.text = report.quantity.toString();
    _userCtrl.text = report.user.toString();
    _notesCtrl.text = report.notes ?? '';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user?.role != 'pic') ...[
                AppHintBoard(
                  title: '📌 Petunjuk Laporan Kematian',
                  desc:
                      '• Tekan Ubah kalau datanya mau diganti.\n• Tekan Hapus kalau laporannya tidak dipakai lagi.',
                ),
                const SizedBox(height: 16),
              ],
              AppInputDate(
                label: 'Tanggal Kematian',
                hint: 'Tanggal Kematian',
                type: DateFieldType.date,
                controller: _reportDateCtrl,
                requiredField: true,
                readOnly: true,
              ),
              const SizedBox(height: 16),
              AppInputText(
                label: 'Jumlah Kematian (ekor)',
                hint: 'Jumlah Kematian',
                controller: _quantityCtrl,
                type: FieldType.number,
                requiredField: true,
                readOnly: true,
              ),
              const SizedBox(height: 16),
              AppInputImage(
                label: 'Foto',
                hint: 'Tambahkan foto kematian ikan lele',
                requiredField: true,
                readOnly: true,
                imageUrl: report.image,
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
              const SizedBox(height: 24),
              if (user?.role != 'pic' &&
                  report.cycleCondition == "active_cultivation") ...[
                AppButton(
                  label: 'Ubah',
                  onPressed: () {
                    AppRoutes.pushNamed(
                      context,
                      AppRoutes.updateMortalityReport,
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
                        await ref
                            .read(
                              mortalityReportMutationNotifierProvider.notifier,
                            )
                            .deleteMortalityReport(
                              widget.reportId,
                              widget.poolId,
                            );

                        final mutationState = ref.read(
                          mortalityReportMutationNotifierProvider,
                        );

                        if (mutationState.hasError) {
                          AppRoutes.pop(context);
                          AppSnackbar.error(mutationState.error.toString());
                        } else {
                          AppRoutes.pop(context);
                          AppSnackbar.success('Laporan berhasil dihapus');
                          AppRoutes.pop(context);
                        }
                      },
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
