import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_snackbar.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/features/parameter/presentation/providers/parameter_provider.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/pool/presentation/providers/pool_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ParameterCardState { view, select, custom }

class ParameterCard extends ConsumerStatefulWidget {
  final Pool? pool;
  const ParameterCard({super.key, required this.pool});

  @override
  ConsumerState<ParameterCard> createState() => _ParameterCardState();
}

class _ParameterCardState extends ConsumerState<ParameterCard> {
  ParameterCardState _state = ParameterCardState.view;
  int _selectedPreset = 0; // 0: Rekomendasi, 1: Ideal, 2: Adaptif

  final TextEditingController _phMaxController = TextEditingController();
  final TextEditingController _phNormalController = TextEditingController();
  final TextEditingController _phMinController = TextEditingController();
  final TextEditingController _tempMaxController = TextEditingController();
  final TextEditingController _tempNormalController = TextEditingController();
  final TextEditingController _tempMinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    if (widget.pool != null) {
      _phMaxController.text = _formatRange(widget.pool!.acidityMax);
      _phNormalController.text = _formatRange(widget.pool!.acidityNormal);
      _phMinController.text = _formatRange(widget.pool!.acidityMin);
      _tempMaxController.text = _formatRange(widget.pool!.temperatureMax);
      _tempNormalController.text = _formatRange(widget.pool!.temperatureNormal);
      _tempMinController.text = _formatRange(widget.pool!.temperatureMin);
    }
  }

  @override
  void dispose() {
    _phMaxController.dispose();
    _phNormalController.dispose();
    _phMinController.dispose();
    _tempMaxController.dispose();
    _tempNormalController.dispose();
    _tempMinController.dispose();
    super.dispose();
  }

  String _formatRange(List<double> range) {
    if (range.isEmpty) return '0-0';
    if (range.length == 1) return '${range.first}';
    return '${range.first}-${range.last}';
  }

  List<double> _parseRange(String input) {
    if (input.isEmpty) return [0.0, 0.0];
    try {
      final parts = input.split('-');
      if (parts.length == 2) {
        return [double.parse(parts[0].trim()), double.parse(parts[1].trim())];
      }
      final val = double.parse(input.trim());
      return [val, val];
    } catch (e) {
      return [0.0, 0.0];
    }
  }

  void _onSave() async {
    List<double> tempMax, tempNorm, tempMin, phMax, phNorm, phMin;

    if (_state == ParameterCardState.select) {
      if (_selectedPreset == 0) {
        // Rekomendasi
        tempMax = [32.1, 35.0];
        tempNorm = [25.0, 32.0];
        tempMin = [20.0, 24.9];
        phMax = [8.6, 14.0];
        phNorm = [6.5, 8.5];
        phMin = [0.0, 6.4];
      } else if (_selectedPreset == 1) {
        // Ideal
        tempMax = [30.1, 35.0];
        tempNorm = [26.0, 30.0];
        tempMin = [20.0, 25.9];
        phMax = [8.1, 14.0];
        phNorm = [7.0, 8.0];
        phMin = [0.0, 6.9];
      } else {
        // Adaptif
        tempMax = [34.1, 40.0];
        tempNorm = [24.0, 34.0];
        tempMin = [15.0, 23.9];
        phMax = [9.1, 14.0];
        phNorm = [6.0, 9.0];
        phMin = [0.0, 5.9];
      }
    } else {
      // Custom
      phMax = _parseRange(_phMaxController.text);
      phNorm = _parseRange(_phNormalController.text);
      phMin = _parseRange(_phMinController.text);
      tempMax = _parseRange(_tempMaxController.text);
      tempNorm = _parseRange(_tempNormalController.text);
      tempMin = _parseRange(_tempMinController.text);
    }

    try {
      if (widget.pool == null) {
        await ref
            .read(parameterMutationNotifierProvider.notifier)
            .updateParameters(tempMax, tempNorm, tempMin, phMax, phNorm, phMin);
      } else {
        await ref
            .read(parameterMutationNotifierProvider.notifier)
            .updateParameter(
              widget.pool!.id,
              tempMax,
              tempNorm,
              tempMin,
              phMax,
              phNorm,
              phMin,
            );
      }

      if (mounted) {
        // Refresh pool list
        await ref.read(poolListNotifierProvider.notifier).getPools();

        // Kembali ke view mode
        setState(() => _state = ParameterCardState.view);

        AppSnackbar.success('Parameter berhasil diperbarui');
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.error('Gagal menyimpan: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(),
          const SizedBox(height: 16),
          if (_state == ParameterCardState.view) _buildViewMode(),
          if (_state == ParameterCardState.select) _buildSelectMode(),
          if (_state == ParameterCardState.custom) _buildCustomMode(),
        ],
      ),
    );
  }

  Widget _buildCardHeader() {
    final title = widget.pool != null ? widget.pool!.name : 'Semua Kolam';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGray,
              ),
            ),
            if (_state == ParameterCardState.view)
              const Text(
                'Parameter Tersimpan',
                style: TextStyle(fontSize: 12, color: AppColors.darkGray),
              ),
            if (_state == ParameterCardState.select)
              const Text(
                'Pilih ambang batas',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGray,
                ),
              ),
            if (_state == ParameterCardState.custom)
              const Text(
                'Tentukan Ambang batas Sendiri',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGray,
                ),
              ),
          ],
        ),
        const Icon(Icons.check_circle, color: AppColors.green, size: 24),
      ],
    );
  }

  Widget _buildViewMode() {
    final isGlobal = widget.pool == null;

    return Column(
      children: [
        if (!isGlobal) ...[
          _buildInfoBox(
            title: 'Ambang batas Max (Atas):',
            backgroundColor: AppColors.lightGray.withValues(alpha: 0.5),
            borderColor: AppColors.gray.withValues(alpha: 0.5),
            content: [
              _buildParameterItem(
                Icons.water_drop,
                'Ph',
                _formatRange(widget.pool!.acidityMax),
                AppColors.primary,
              ),
              _buildParameterItem(
                Icons.thermostat,
                'Suhu',
                '${_formatRange(widget.pool!.temperatureMax)}°C',
                AppColors.secondary,
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoBox(
            title: 'Ambang batas Normal:',
            backgroundColor: AppColors.lightGray.withValues(alpha: 0.5),
            borderColor: AppColors.gray.withValues(alpha: 0.5),
            content: [
              _buildParameterItem(
                Icons.water_drop,
                'Ph',
                _formatRange(widget.pool!.acidityNormal),
                AppColors.primary,
              ),
              _buildParameterItem(
                Icons.thermostat,
                'Suhu',
                '${_formatRange(widget.pool!.temperatureNormal)}°C',
                AppColors.secondary,
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoBox(
            title: 'Ambang batas Min (Bawah):',
            backgroundColor: AppColors.lightGray.withValues(alpha: 0.5),
            borderColor: AppColors.gray.withValues(alpha: 0.5),
            content: [
              _buildParameterItem(
                Icons.water_drop,
                'Ph',
                _formatRange(widget.pool!.acidityMin),
                AppColors.primary,
              ),
              _buildParameterItem(
                Icons.thermostat,
                'Suhu',
                '${_formatRange(widget.pool!.temperatureMin)}°C',
                AppColors.secondary,
              ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        AppButton(
          label: 'Ubah Pengaturan',
          onPressed: () => setState(() => _state = ParameterCardState.select),
        ),
      ],
    );
  }

  Widget _buildSelectMode() {
    final isLoading = ref.watch(parameterMutationNotifierProvider).isLoading;

    return Column(
      children: [
        _buildPresetOption(
          index: 0,
          title: 'Ambang Rekomendasi',
          subtitle: 'Rentang umum yang direkomendasikan untuk budidaya lele',
          phMax: '8.6 - 14.0',
          phNormal: '6.5 - 8.5',
          phMin: '0.0 - 6.4',
          tempMax: '32.1°C - 35.0°C',
          tempNormal: '25°C - 32°C',
          tempMin: '20.0°C - 24.9°C',
        ),
        const SizedBox(height: 12),
        _buildPresetOption(
          index: 1,
          title: 'Ambang Ideal',
          subtitle:
              'Rentang ketat untuk mendukung pertumbuhan lele secara optimal',
          phMax: '8.1 - 14.0',
          phNormal: '7.0 - 8.0',
          phMin: '0.0 - 6.9',
          tempMax: '30.1°C - 35.0°C',
          tempNormal: '26°C - 30°C',
          tempMin: '20.0°C - 25.9°C',
        ),
        const SizedBox(height: 12),
        _buildPresetOption(
          index: 2,
          title: 'Ambang Adaptif',
          subtitle:
              'Rentang luas untuk kondisi budidaya dengan toleransi tinggi.',
          phMax: '9.1 - 14.0',
          phNormal: '6.0 - 9.0',
          phMin: '0.0 - 5.9',
          tempMax: '34.1°C - 40.0°C',
          tempNormal: '24°C - 34°C',
          tempMin: '15.0°C - 23.9°C',
        ),
        const SizedBox(height: 16),
        AppButton(
          label: 'Lainnya (Custom)',
          color: AppColors.secondary,
          onPressed: () => setState(() => _state = ParameterCardState.custom),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'Simpan',
                onPressed: _onSave,
                isLoading: isLoading,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                label: 'Batal',
                isOutlined: true,
                onPressed: () =>
                    setState(() => _state = ParameterCardState.view),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPresetOption({
    required int index,
    required String title,
    required String subtitle,
    required String phMax,
    required String phNormal,
    required String phMin,
    required String tempMax,
    required String tempNormal,
    required String tempMin,
  }) {
    bool isSelected = _selectedPreset == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPreset = index),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F9ED) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.green : AppColors.gray,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: AppColors.darkGray),
            ),
            const SizedBox(height: 12),
            const Text(
              'Ambang batas Max (Atas):',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildParameterItem(
                  Icons.water_drop,
                  'Ph',
                  phMax,
                  AppColors.primary,
                  small: true,
                ),
                const SizedBox(width: 24),
                _buildParameterItem(
                  Icons.thermostat,
                  'Suhu',
                  tempMax,
                  AppColors.secondary,
                  small: true,
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Ambang batas Normal:',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildParameterItem(
                  Icons.water_drop,
                  'Ph',
                  phNormal,
                  AppColors.primary,
                  small: true,
                ),
                const SizedBox(width: 24),
                _buildParameterItem(
                  Icons.thermostat,
                  'Suhu',
                  tempNormal,
                  AppColors.secondary,
                  small: true,
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Ambang batas Min (Bawah):',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildParameterItem(
                  Icons.water_drop,
                  'Ph',
                  phMin,
                  AppColors.primary,
                  small: true,
                ),
                const SizedBox(width: 24),
                _buildParameterItem(
                  Icons.thermostat,
                  'Suhu',
                  tempMin,
                  AppColors.secondary,
                  small: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomMode() {
    final isLoading = ref.watch(parameterMutationNotifierProvider).isLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Parameter Suhu',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        AppInputText(
          label: 'Suhu Max (Bahaya Atas)',
          hint: 'Contoh: 32-40',
          controller: _tempMaxController,
        ),
        const SizedBox(height: 8),
        AppInputText(
          label: 'Suhu Normal',
          hint: 'Contoh: 25-32',
          controller: _tempNormalController,
        ),
        const SizedBox(height: 8),
        AppInputText(
          label: 'Suhu Min (Bahaya Bawah)',
          hint: 'Contoh: 0-24',
          controller: _tempMinController,
        ),
        const SizedBox(height: 16),
        const Text(
          'Parameter pH',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        AppInputText(
          label: 'pH Max (Bahaya Atas)',
          hint: 'Contoh: 8.6-14',
          controller: _phMaxController,
        ),
        const SizedBox(height: 8),
        AppInputText(
          label: 'pH Normal',
          hint: 'Contoh: 6.5-8.5',
          controller: _phNormalController,
        ),
        const SizedBox(height: 8),
        AppInputText(
          label: 'pH Min (Bahaya Bawah)',
          hint: 'Contoh: 0-6.4',
          controller: _phMinController,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'Simpan',
                onPressed: _onSave,
                isLoading: isLoading,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                label: 'Kembali',
                isOutlined: true,
                onPressed: () =>
                    setState(() => _state = ParameterCardState.select),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoBox({
    required String title,
    required Color backgroundColor,
    required Color borderColor,
    required List<Widget> content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: content,
          ),
        ],
      ),
    );
  }

  Widget _buildParameterItem(
    IconData icon,
    String label,
    String value,
    Color iconColor, {
    bool small = false,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: small ? 18 : 24),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(value, style: TextStyle(fontSize: 12, color: Colors.black)),
          ],
        ),
      ],
    );
  }
}
