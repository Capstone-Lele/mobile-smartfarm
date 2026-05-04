import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_dialog.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_dropdown.dart';

import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_snackbar.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_submission_detail.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/providers/inventory_submission_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InventorySubmissionDetailPage extends ConsumerStatefulWidget {
  final String inventorySubmissionId;

  const InventorySubmissionDetailPage({
    super.key,
    required this.inventorySubmissionId,
  });

  @override
  ConsumerState<InventorySubmissionDetailPage> createState() =>
      _InventorySubmissionDetailPageState();
}

class _InventorySubmissionDetailPageState
    extends ConsumerState<InventorySubmissionDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _quantityCtrl = TextEditingController();
  final _statusCtrl = TextEditingController();
  final _feedbackCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _userCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _getReportDetail());
  }

  @override
  void dispose() {
    _quantityCtrl.dispose();
    _statusCtrl.dispose();
    _feedbackCtrl.dispose();
    _notesCtrl.dispose();
    _userCtrl.dispose();
    super.dispose();
  }

  Future<void> _getReportDetail() async {
    await ref
        .read(inventorySubmissionDetailNotifierProvider.notifier)
        .getInventorySubmission(widget.inventorySubmissionId);
  }

  @override
  Widget build(BuildContext context) {
    final inventorySubmissionAsync = ref.watch(
      inventorySubmissionDetailNotifierProvider,
    );

    return Scaffold(
      appBar: _buildHeader(context),
      body: inventorySubmissionAsync.when(
        loading: () => _buildLoadingState(),
        error: (err, stack) => _buildErrorState(err),
        data: (inventorySubmission) => _buildFormState(inventorySubmission),
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
            'Detail Pengajuan Inventaris',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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

  Widget _buildFormState(InventorySubmissionDetail? inventorySubmission) {
    if (inventorySubmission == null) {
      return const Center(child: Text('Pengajuan inventaris tidak ditemukan'));
    }

    _quantityCtrl.text = inventorySubmission.quantity.toString();
    _statusCtrl.text = inventorySubmission.status;
    _feedbackCtrl.text = inventorySubmission.feedback ?? '';
    _notesCtrl.text = inventorySubmission.notes ?? '';
    _userCtrl.text = inventorySubmission.user;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppInputDropdown<String>(
                label: 'Nama Produk',
                hint: 'Pilh Produk',
                items: [inventorySubmission.product],
                value: inventorySubmission.product,
                itemLabel: (item) => item,
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
                label: 'Status',
                hint: 'Status',
                controller: _statusCtrl,
                type: FieldType.text,
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
                readOnly: true,
              ),
              if (inventorySubmission.status == 'rejected') ...[
                SizedBox(height: 16),
                AppInputText(
                  label: 'Feedback',
                  hint: 'Feedback',
                  controller: _feedbackCtrl,
                  type: FieldType.text,
                  maxLines: 5,
                  minLines: 3,
                  requiredField: false,
                  readOnly: true,
                ),
              ],
              SizedBox(height: 16),
              AppInputText(
                label: 'Pengaju',
                hint: 'Pengaju',
                controller: _userCtrl,
                type: FieldType.text,
                requiredField: true,
                readOnly: true,
              ),
              const SizedBox(height: 24),
              if (inventorySubmission.status == 'pending') ...[
                AppButton(
                  label: 'Ubah',
                  onPressed: () {
                    AppRoutes.pushNamed(
                      context,
                      AppRoutes.updateInventorySubmission,
                      arguments: {
                        'inventorySubmissionId': widget.inventorySubmissionId,
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
                      title: 'Hapus Pengajuan',
                      message:
                          'Apakah anda yakin ingin menghapus pengajuan ini?',
                      confirmText: 'Iya',
                      cancelText: 'Tidak',
                      onConfirm: () async {
                        await ref
                            .read(
                              inventorySubmissionMutationNotifierProvider
                                  .notifier,
                            )
                            .deleteInventorySubmission(
                              widget.inventorySubmissionId,
                            );

                        final mutationState = ref.read(
                          inventorySubmissionMutationNotifierProvider,
                        );
                        if (mutationState.hasError) {
                          AppSnackbar.error(mutationState.error.toString());
                          AppRoutes.pop(context);
                        } else {
                          AppRoutes.pop(context);
                          AppSnackbar.success('Pengajuan berhasil dihapus');
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
