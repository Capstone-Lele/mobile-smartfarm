import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

enum ParameterCardState { view, select, custom }

class ParameterCard extends StatefulWidget {
  final Map<String, dynamic> pool;
  const ParameterCard({super.key, required this.pool});

  @override
  State<ParameterCard> createState() => _ParameterCardState();
}

class _ParameterCardState extends State<ParameterCard> {
  ParameterCardState _state = ParameterCardState.view;
  int _selectedPreset = 0; // 0: Rekomendasi, 1: Ideal, 2: Adaptif

  final TextEditingController _phController = TextEditingController();
  final TextEditingController _tempController = TextEditingController();

  @override
  void dispose() {
    _phController.dispose();
    _tempController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.pool['name'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGray,
              ),
            ),
            if (_state == ParameterCardState.view)
              Text(
                widget.pool['thresholdType'],
                style: const TextStyle(fontSize: 12, color: AppColors.darkGray),
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
    return Column(
      children: [
        _buildInfoBox(
          title: 'Nilai Saat Ini:',
          backgroundColor: const Color(0xFFF0F9ED),
          borderColor: const Color(0xFFB7E4C7).withOpacity(0.5),
          content: [
            _buildParameterItem(
              Icons.water_drop,
              'Ph',
              '${widget.pool['currentPh']}',
              const Color(0xFF2D6A4F),
            ),
            _buildParameterItem(
              Icons.thermostat,
              'Suhu',
              '${widget.pool['currentTemp']}°C',
              const Color(0xFF2D6A4F),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildInfoBox(
          title: 'Ambang batas saat ini:',
          backgroundColor: AppColors.lightGray.withOpacity(0.5),
          borderColor: AppColors.gray.withOpacity(0.5),
          content: [
            _buildParameterItem(
              Icons.water_drop,
              'Ph',
              widget.pool['phRange'],
              AppColors.primary,
            ),
            _buildParameterItem(
              Icons.thermostat,
              'Suhu',
              widget.pool['tempRange'],
              AppColors.secondary,
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppButton(
          label: 'Ubah Pengaturan',
          onPressed: () => setState(() => _state = ParameterCardState.select),
        ),
      ],
    );
  }

  Widget _buildSelectMode() {
    return Column(
      children: [
        _buildPresetOption(
          index: 0,
          title: 'Ambang Rekomendasi',
          subtitle: 'Rentang umum yang direkomendasikan untuk budidaya lele',
          ph: '6.5 - 8.5',
          temp: '25°C - 32°C',
        ),
        const SizedBox(height: 12),
        _buildPresetOption(
          index: 1,
          title: 'Ambang Ideal',
          subtitle:
              'Rentang ketat untuk mendukung pertumbuhan lele secara optimal',
          ph: '7 - 8',
          temp: '26°C - 30°C',
        ),
        const SizedBox(height: 12),
        _buildPresetOption(
          index: 2,
          title: 'Ambang Adaptif',
          subtitle:
              'Rentang luas untuk kondisi budidaya dengan toleransi tinggi.',
          ph: '6 - 9',
          temp: '24°C - 34°C',
        ),
        const SizedBox(height: 16),
        AppButton(
          label: 'Lainnya',
          color: AppColors.secondary,
          onPressed: () => setState(() => _state = ParameterCardState.custom),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'Simpan',
                onPressed: () =>
                    setState(() => _state = ParameterCardState.view),
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
    required String ph,
    required String temp,
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
            const SizedBox(height: 8),
            Row(
              children: [
                _buildParameterItem(
                  Icons.water_drop,
                  'Ph',
                  ph,
                  AppColors.primary,
                  small: true,
                ),
                const SizedBox(width: 24),
                _buildParameterItem(
                  Icons.thermostat,
                  'Suhu',
                  temp,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoBox(
          title: 'Nilai Saat Ini:',
          backgroundColor: const Color(0xFFF0F9ED),
          borderColor: const Color(0xFFB7E4C7).withOpacity(0.5),
          content: [
            _buildParameterItem(
              Icons.water_drop,
              'Ph',
              '${widget.pool['currentPh']}',
              const Color(0xFF2D6A4F),
            ),
            _buildParameterItem(
              Icons.thermostat,
              'Suhu',
              '${widget.pool['currentTemp']}°C',
              const Color(0xFF2D6A4F),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppInputText(
          label: 'Ambang Batas pH',
          hint: 'Ambang Batas pH',
          requiredField: true,
          controller: _phController,
        ),
        const Text(
          'Contoh: 7-9',
          style: TextStyle(fontSize: 12, color: AppColors.darkGray),
        ),
        const SizedBox(height: 16),
        AppInputText(
          label: 'Ambang Batas Suhu',
          hint: 'Ambang Batas Suhu',
          requiredField: true,
          controller: _tempController,
        ),
        const Text(
          'Contoh: 24-39',
          style: TextStyle(fontSize: 12, color: AppColors.darkGray),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'Simpan',
                onPressed: () =>
                    setState(() => _state = ParameterCardState.view),
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
                fontSize: small ? 10 : 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              value,
              style: TextStyle(fontSize: small ? 10 : 12, color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }
}
