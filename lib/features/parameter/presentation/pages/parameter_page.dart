import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/features/parameter/presentation/widgets/parameter_card.dart';
import 'package:flutter/material.dart';

class ParameterPage extends StatefulWidget {
  const ParameterPage({super.key});

  @override
  State<ParameterPage> createState() => _ParameterPageState();
}

class _ParameterPageState extends State<ParameterPage> {
  final List<Map<String, dynamic>> _dummyPools = [
    {
      'id': '1',
      'name': 'Kolam 1',
      'currentPh': 7.2,
      'currentTemp': 28,
      'thresholdType': 'Ambang Rekomendasi',
      'phRange': '6.5 - 8.5',
      'tempRange': '25°C - 32°C',
    },
    {
      'id': '2',
      'name': 'Kolam 2',
      'currentPh': 7.2,
      'currentTemp': 28,
      'thresholdType': 'Ambang Ideal',
      'phRange': '7 - 8',
      'tempRange': '26°C - 30°C',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildHeader(context),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _dummyPools.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            return ParameterCard(pool: _dummyPools[index]);
          },
        ),
      ),
    );
  }

  AppBar _buildHeader(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Manajemen Parameter',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Pengaturan',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.darkGray,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
