import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_dialog.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_date.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_dropdown.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_snackbar.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/schedule.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/providers/cleaning_provider.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/providers/feeding_provider.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/providers/sampling_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleDetailPage extends ConsumerStatefulWidget {
  final String scheduleId;
  final String scheduleType;

  const ScheduleDetailPage({
    required this.scheduleId,
    required this.scheduleType,
    super.key,
  });

  @override
  ConsumerState<ScheduleDetailPage> createState() => _ScheduleDetailPageState();
}

class _ScheduleDetailPageState extends ConsumerState<ScheduleDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _poolNameCtrl = TextEditingController();
  final _userCtrl = TextEditingController();
  final _scheduleDateCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _getScheduleDetail());
  }

  @override
  void dispose() {
    _poolNameCtrl.dispose();
    _userCtrl.dispose();
    _scheduleDateCtrl.dispose();
    super.dispose();
  }

  Future<void> _getScheduleDetail() async {
    switch (widget.scheduleType) {
      case 'cleaning':
        await ref
            .read(cleaningDetailNotifierProvider.notifier)
            .getCleaningSchedule(widget.scheduleId);
        break;
      case 'feeding':
        await ref
            .read(feedingDetailNotifierProvider.notifier)
            .getFeedingSchedule(widget.scheduleId);
        break;
      case 'sampling':
        await ref
            .read(samplingDetailNotifierProvider.notifier)
            .getSamplingSchedule(widget.scheduleId);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheduleAsync = _getScheduleProvider();

    return Scaffold(
      appBar: _buildHeader(context),
      body: scheduleAsync.when(
        loading: () => _buildLoadingState(),
        error: (err, stack) => _buildErrorState(err),
        data: (schedule) => _buildFormState(schedule),
      ),
    );
  }

  AsyncValue<Schedule?> _getScheduleProvider() {
    return switch (widget.scheduleType) {
      'cleaning' => ref.watch(cleaningDetailNotifierProvider),
      'feeding' => ref.watch(feedingDetailNotifierProvider),
      'sampling' => ref.watch(samplingDetailNotifierProvider),
      _ => const AsyncValue.data(null),
    };
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
            'Detail Jadwal',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            widget.scheduleType == 'cleaning'
                ? 'Pembersihan Kolam'
                : widget.scheduleType == 'feeding'
                ? 'Pemberian Pakan'
                : widget.scheduleType == 'sampling'
                ? 'Pengambilan Sampel'
                : 'Jadwal Tidak Dikenal',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(child: const CircularProgressIndicator());
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
          AppButton(label: 'Coba Lagi', onPressed: () => _getScheduleDetail()),
        ],
      ),
    );
  }

  Widget _buildFormState(Schedule? schedule) {
    if (schedule == null) {
      return const Center(child: Text('Jadwal tidak ditemukan'));
    }
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppInputDropdown<String>(
                  label: 'Nama Kolam',
                  hint: 'Pilih Kolam',
                  value: schedule.poolName,
                  items: [schedule.poolName],
                  itemLabel: (pool) => pool,
                  requiredField: true,
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                AppInputDropdown<String>(
                  label: 'Nama Petugas',
                  hint: 'Pilih Petugas',
                  value: schedule.userName,
                  items: [schedule.userName],
                  itemLabel: (user) => user,
                  requiredField: true,
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                AppInputDate(
                  label: 'Tanggal Jadwal',
                  hint: 'Pilih Tanggal',
                  type: DateFieldType.dateTime,
                  controller: _scheduleDateCtrl..text = schedule.scheduleDate,
                  requiredField: true,
                  readOnly: true,
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: 'Ubah',
                  onPressed: () {
                    AppRoutes.pushNamed(
                      context,
                      AppRoutes.updateSchedule,
                      arguments: {
                        'scheduleId': schedule.id,
                        'scheduleType': widget.scheduleType,
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
                      title: 'Hapus Jadwal',
                      message: 'Apakah anda yakin ingin menghapus jadwal ini?',
                      confirmText: 'Iya',
                      cancelText: 'Tidak',
                      onConfirm: () async {
                        switch (widget.scheduleType) {
                          case 'cleaning':
                            await ref
                                .read(cleaningMutationNotifierProvider.notifier)
                                .deleteCleaningSchedule(schedule.id);
                            break;
                          case 'feeding':
                            await ref
                                .read(feedingMutationNotifierProvider.notifier)
                                .deleteFeedingSchedule(schedule.id);
                            break;
                          case 'sampling':
                            await ref
                                .read(samplingMutationNotifierProvider.notifier)
                                .deleteSamplingSchedule(schedule.id);
                            break;
                        }

                        final mutationState = switch (widget.scheduleType) {
                          'cleaning' => ref.watch(
                            cleaningMutationNotifierProvider,
                          ),
                          'feeding' => ref.watch(
                            feedingMutationNotifierProvider,
                          ),
                          'sampling' => ref.watch(
                            samplingMutationNotifierProvider,
                          ),
                          _ => const AsyncValue.data(null),
                        };

                        if (mutationState.hasError) {
                          AppRoutes.pop(context);
                          AppSnackbar.error(mutationState.error.toString());
                        } else {
                          AppRoutes.pop(context);
                          AppSnackbar.success('Jadwal berhasil dihapus');
                          AppRoutes.pop(context);
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
