import 'package:budidaya_lele_mobile/common/widgets/app_status_badge.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class StatusDevicePage extends StatefulWidget {
  const StatusDevicePage({super.key});

  @override
  State<StatusDevicePage> createState() => _StatusDevicePageState();
}

class _StatusDevicePageState extends State<StatusDevicePage> {
  final Map<String, List<Map<String, dynamic>>> _poolDevices = {
    'Kolam 1': [
      {'name': 'Alat Pengukur pH', 'status': 'Aktif', 'isActive': true},
      {'name': 'Alat Pengukur Suhu', 'status': 'Aktif', 'isActive': true},
      {
        'name': 'Alat Pakan Otomatis',
        'status': 'Tidak Aktif',
        'isActive': false,
      },
    ],
    'Kolam 2': [
      {'name': 'Alat Pengukur pH', 'status': 'Aktif', 'isActive': true},
      {'name': 'Alat Pengukur Suhu', 'status': 'Aktif', 'isActive': true},
      {'name': 'Alat Pakan Otomatis', 'status': 'Aktif', 'isActive': true},
    ],
    'Kolam 3': [
      {'name': 'Alat Pengukur pH', 'status': 'Aktif', 'isActive': true},
      {
        'name': 'Alat Pengukur Suhu',
        'status': 'Tidak Aktif',
        'isActive': false,
      },
      {'name': 'Alat Pakan Otomatis', 'status': 'Aktif', 'isActive': true},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildHeader(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {},
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPoolCard('Kolam 1', _poolDevices['Kolam 1']!),
                const SizedBox(height: 12),
                _buildPoolCard('Kolam 2', _poolDevices['Kolam 2']!),
                const SizedBox(height: 12),
                _buildPoolCard('Kolam 3', _poolDevices['Kolam 3']!),
              ],
            ),
          ),
        ),
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
            'Status Alat',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            'Pengaturan',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPoolCard(String poolName, List<Map<String, dynamic>> devices) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray, width: 1),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            poolName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          trailing: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.darkGray,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Daftar Alat',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.darkGray,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ...devices.map((device) => _buildDeviceItem(device)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceItem(Map<String, dynamic> device) {
    final bool isActive = device['isActive'] as bool;
    final String name = device['name'] as String;
    final String status = device['status'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(Icons.wifi, size: 20, color: AppColors.black),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
          ),
          AppStatusBadge(
            label: status,
            type: isActive ? BadgeType.success : BadgeType.danger,
          ),
        ],
      ),
    );
  }
}
