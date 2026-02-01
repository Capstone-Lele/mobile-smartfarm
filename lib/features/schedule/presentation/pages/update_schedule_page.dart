import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_date.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_dropdown.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_snackbar.dart';
import 'package:budidaya_lele_mobile/core/utils/app_format.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/pool/presentation/providers/pool_provider.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/auto_fill.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/schedule.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/providers/auto_fill_provider.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/providers/cleaning_provider.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/providers/feeding_provider.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/providers/sampling_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateSchedulePage extends ConsumerStatefulWidget {
  final String scheduleId;
  final String scheduleType;

  const UpdateSchedulePage({
    super.key,
    required this.scheduleId,
    required this.scheduleType,
  });

  @override
  ConsumerState<UpdateSchedulePage> createState() => _UpdateSchedulePageState();
}

class _UpdateSchedulePageState extends ConsumerState<UpdateSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  final _scheduleDateCtrl = TextEditingController();

  Pool? _selectedPool;
  AutoFill? _selectedAutoFill;
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialData());
  }

  @override
  void dispose() {
    _scheduleDateCtrl.dispose();
    super.dispose();
  }

  Future<void> _initialData() async {
    try {
      setState(() {
        _isInitialLoading = true;
      });

      await ref.read(poolListNotifierProvider.notifier).getPools();

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

      final scheduleData = _getScheduleDetailState(watch: false);
      if (scheduleData.hasValue && scheduleData.value != null) {
        final schedule = scheduleData.value as Schedule;

        final pools = ref.read(poolListNotifierProvider).value ?? [];
        Pool? foundPool;
        for (final p in pools) {
          if (p.name == schedule.poolName) {
            foundPool = p;
            break;
          }
        }
        _selectedPool = foundPool ?? (pools.isNotEmpty ? pools.first : null);

        if (_selectedPool != null) {
          await ref
              .read(autoFillListNotifierProvider.notifier)
              .getAutoFills(_selectedPool!.id);

          final autofills = ref.read(autoFillListNotifierProvider).value ?? [];
          AutoFill? foundAutoFill;
          for (final a in autofills) {
            if (a.name == schedule.userName) {
              foundAutoFill = a;
              break;
            }
          }
          _selectedAutoFill =
              foundAutoFill ?? (autofills.isNotEmpty ? autofills.first : null);
        }

        _scheduleDateCtrl.text = schedule.scheduleDate;
      }
    } catch (e) {
      debugPrint('Error loading initial data: $e');
    } finally {
      if (mounted) {
        setState(() => _isInitialLoading = false);
      }
    }
  }

  AsyncValue<dynamic> _getScheduleDetailState({bool watch = true}) {
    if (watch) {
      return switch (widget.scheduleType) {
        'cleaning' => ref.watch(cleaningDetailNotifierProvider),
        'feeding' => ref.watch(feedingDetailNotifierProvider),
        'sampling' => ref.watch(samplingDetailNotifierProvider),
        _ => const AsyncValue.data(null),
      };
    } else {
      return switch (widget.scheduleType) {
        'cleaning' => ref.read(cleaningDetailNotifierProvider),
        'feeding' => ref.read(feedingDetailNotifierProvider),
        'sampling' => ref.read(samplingDetailNotifierProvider),
        _ => const AsyncValue.data(null),
      };
    }
  }

  Future<void> _onPoolSelected(Pool? pool) async {
    setState(() {
      _selectedPool = pool;
      _selectedAutoFill = null;
    });

    if (pool != null) {
      await ref
          .read(autoFillListNotifierProvider.notifier)
          .getAutoFills(pool.id);
    }
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPool == null || _selectedAutoFill == null) return;

    final dateApi = AppFormat.toApiDateTime(_scheduleDateCtrl.text);

    switch (widget.scheduleType) {
      case 'cleaning':
        await ref
            .read(cleaningMutationNotifierProvider.notifier)
            .updateCleaningSchedule(
              widget.scheduleId,
              _selectedPool!.id,
              _selectedAutoFill!.id,
              dateApi,
            );
        break;
      case 'feeding':
        await ref
            .read(feedingMutationNotifierProvider.notifier)
            .updateFeedingSchedule(
              widget.scheduleId,
              _selectedPool!.id,
              _selectedAutoFill!.id,
              dateApi,
            );
        break;
      case 'sampling':
        await ref
            .read(samplingMutationNotifierProvider.notifier)
            .updateSamplingSchedule(
              widget.scheduleId,
              _selectedPool!.id,
              _selectedAutoFill!.id,
              dateApi,
            );
        break;
    }

    final mutationState = switch (widget.scheduleType) {
      'cleaning' => ref.read(cleaningMutationNotifierProvider),
      'feeding' => ref.read(feedingMutationNotifierProvider),
      'sampling' => ref.read(samplingMutationNotifierProvider),
      _ => const AsyncValue.data(null),
    };

    if (mutationState.hasError) {
      AppSnackbar.error(mutationState.error.toString());
    } else {
      AppSnackbar.success('Jadwal berhasil diubah');
      AppRoutes.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pools = ref.watch(poolListNotifierProvider);
    final autoFills = ref.watch(autoFillListNotifierProvider);
    final detail = _getScheduleDetailState(watch: true);

    final isLoading = _isInitialLoading || detail.isLoading || pools.isLoading;
    final error = detail.error ?? pools.error;

    return Scaffold(
      appBar: _buildHeader(context),
      body: SafeArea(
        child: isLoading
            ? _buildLoadingState()
            : error != null
            ? _buildErrorState(error)
            : _buildFormState(pools.value ?? [], autoFills),
      ),
    );
  }

  String _getAsyncHint(AsyncValue<List<AutoFill>> autoFillsState) {
    return autoFillsState.when(
      loading: () => 'Loading petugas...',
      error: (err, stack) => 'Error loading petugas',
      data: (data) =>
          data.isEmpty ? 'Pilih Kolam Terlebih Dahulu' : 'Pilih Petugas',
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
            'Ubah Jadwal',
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
          ElevatedButton(
            onPressed: () => _initialData(),
            child: const Text(
              'Coba Lagi',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormState(
    List<Pool> poolList,
    AsyncValue<List<AutoFill>> autoFills,
  ) {
    final petugasList = autoFills.whenData((data) => data).value ?? [];
    final petugasAsyncHint = _getAsyncHint(autoFills);
    final isPoolSelected = _selectedPool != null;
    final isLoadingPetugas = autoFills.isLoading;
    final hasErrorPetugas = autoFills.hasError;

    final mutationState = switch (widget.scheduleType) {
      'cleaning' => ref.watch(cleaningMutationNotifierProvider),
      'feeding' => ref.watch(feedingMutationNotifierProvider),
      'sampling' => ref.watch(samplingMutationNotifierProvider),
      _ => const AsyncValue.data(null),
    };

    final isLoading = mutationState.isLoading;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppInputDropdown<Pool>(
              label: 'Nama Kolam',
              hint: 'Pilih Kolam',
              value: _selectedPool,
              items: poolList,
              itemLabel: (pool) => pool.name,
              requiredField: true,
              onChanged: _onPoolSelected,
              validator: (value) {
                if (value == null) {
                  return 'Kolam harus dipilih';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppInputDropdown<AutoFill>(
              label: 'Nama Petugas',
              hint: petugasAsyncHint,
              value: _selectedAutoFill,
              items: petugasList,
              itemLabel: (petugas) => petugas.name,
              requiredField: true,
              readOnly: !isPoolSelected || isLoadingPetugas || hasErrorPetugas,
              onChanged: (petugas) {
                setState(() {
                  _selectedAutoFill = petugas;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Petugas harus dipilih';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppInputDate(
              label: 'Tanggal Jadwal',
              hint: 'Pilih Tanggal',
              type: DateFieldType.dateTime,
              controller: _scheduleDateCtrl,
              requiredField: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tanggal jadwal harus dipilih';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : AppButton(label: 'Submit', onPressed: _onSubmit),
          ],
        ),
      ),
    );
  }
}
