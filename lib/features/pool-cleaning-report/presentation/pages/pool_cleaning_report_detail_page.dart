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
import 'package:budidaya_lele_mobile/features/auth/domain/entities/user.dart';
import 'package:budidaya_lele_mobile/features/auth/presentation/providers/user_provider.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/domain/entities/pool_cleaning_report.dart';
import 'package:budidaya_lele_mobile/features/pool-cleaning-report/presentation/providers/pool_cleaning_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PoolCleaningReportDetailPage extends ConsumerStatefulWidget {
  final String reportId;
  final String poolId;
  final String poolName;

  const PoolCleaningReportDetailPage({
    super.key,
    required this.reportId,
    required this.poolId,
    required this.poolName,
  });

  @override
  ConsumerState<PoolCleaningReportDetailPage> createState() =>
      _PoolCleaningReportDetailPageState();
}

class _PoolCleaningReportDetailPageState
    extends ConsumerState<PoolCleaningReportDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _reportDateCtrl = TextEditingController();
  final _userCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _getReportDetail());
  }

  @override
  void dispose() {
    _reportDateCtrl.dispose();
    _userCtrl.dispose();
    super.dispose();
  }

  Future<void> _getReportDetail() async {
    await ref
        .read(poolCleaningReportDetailNotifierProvider.notifier)
        .getPoolCleaningReport(widget.reportId);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final reportAsync = ref.watch(poolCleaningReportDetailNotifierProvider);

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
            'Detail Laporan Pembersihan',
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

  Widget _buildFormState(PoolCleaningReport? report, User? user) {
    if (report == null) {
      return const Center(child: Text('Laporan tidak ditemukan'));
    }

    _reportDateCtrl.text = AppFormat.toUiDateTime(report.reportDate);
    _userCtrl.text = report.user;

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
                  title: '📌 Petunjuk Laporan Pembersihan Kolam',
                  desc:
                      '• Tekan Ubah kalau datanya mau diganti.\n• Tekan Hapus kalau laporannya tidak dipakai lagi.',
                ),
                const SizedBox(height: 16),
              ],
              AppInputDate(
                label: 'Tanggal Pembersihan Kolam',
                hint: 'Tanggal Pembersihan Kolam',
                type: DateFieldType.dateTime,
                controller: _reportDateCtrl,
                requiredField: true,
                readOnly: true,
              ),
              const SizedBox(height: 16),
              AppInputImage(
                label: 'Foto',
                hint: 'Tambahkan foto pembersihan kolam',
                requiredField: true,
                readOnly: true,
                imageUrl: report.image,
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
              if (user?.role != 'pic') ...[
                const SizedBox(height: 24),
                AppButton(
                  label: 'Ubah',
                  onPressed: () {
                    AppRoutes.pushNamed(
                      context,
                      AppRoutes.updatePoolCleaningReport,
                      arguments: {
                        'reportId': widget.reportId,
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
                              poolCleaningReportMutationNotifierProvider
                                  .notifier,
                            )
                            .deletePoolCleaningReport(
                              widget.reportId,
                              widget.poolId,
                            );

                        final mutationState = ref.read(
                          poolCleaningReportMutationNotifierProvider,
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
