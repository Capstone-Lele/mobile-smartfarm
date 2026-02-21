import 'package:budidaya_lele_mobile/common/widgets/app_date_range_filter.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_hint_board.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:flutter/material.dart';

class SamplingReportPage extends StatefulWidget {
  final String cycleId;
  final String poolId;
  final String poolName;

  const SamplingReportPage({
    super.key,
    required this.cycleId,
    required this.poolId,
    required this.poolName,
  });

  @override
  State<SamplingReportPage> createState() => _SamplingReportPageState();
}

class _SamplingReportPageState extends State<SamplingReportPage> {
  DateTime? _startDate;
  DateTime? _endDate;

  final List<Map<String, dynamic>> _samplingReports = [
    {
      'id': 1,
      'title': 'Laporan Sampling Kolam #1',
      'date': 'Senin, 29 September 2025 08.30',
      'quantity': 100,
      'averageWeight': 5.0,
      'image': 'https://picsum.photos/200',
    },
    {
      'id': 2,
      'title': 'Laporan Sampling Kolam #2',
      'date': 'Senin, 29 September 2025 08.30',
      'quantity': 101,
      'averageWeight': 5.1,
      'image': 'https://picsum.photos/201',
    },
    {
      'id': 3,
      'title': 'Laporan Sampling Kolam #3',
      'date': 'Senin, 29 September 2025 08.30',
      'quantity': 102,
      'averageWeight': 5.2,
      'image': '',
    },
  ];

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
              children: [
                AppHintBoard(
                  title: '📌 Petunjuk Laporan Sampling',
                  desc:
                      '• Tekan + untuk tambah laporan kalau anda melakukan sampling.\n• Ketuk laporan untuk lihat detailnya.',
                ),
                SizedBox(height: 16),
                AppDateRangeFilter(
                  startDate: _startDate,
                  endDate: _endDate,
                  onFilter: (start, end) {
                    setState(() {
                      _startDate = start;
                      _endDate = end;
                    });
                  },
                  onReset: () {
                    setState(() {
                      _startDate = null;
                      _endDate = null;
                    });
                  },
                ),
                SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _samplingReports.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final report = _samplingReports[index];
                    return _buildReportItem(report);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
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
            'Daftar Laporan Sampling',
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

  Widget _buildReportItem(Map<String, dynamic> report) {
    return GestureDetector(
      onTap: () {
        AppRoutes.pushNamed(
          context,
          AppRoutes.samplingReportDetail,
          arguments: {
            'reportId': '${report['id']}',
            'cycleId': widget.cycleId,
            'poolId': widget.poolId,
            'poolName': widget.poolName,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.darkGray),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                report['image'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 60,
                  height: 60,
                  color: AppColors.gray,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: AppColors.darkGray,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report['title'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Jumlah: ${report['quantity']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.darkGray,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Berat Rata²: ${report['averageWeight']} gr',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.darkGray,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    report['date'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.darkGray,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: AppColors.secondary,
      onPressed: () {
        AppRoutes.pushNamed(
          context,
          AppRoutes.createSamplingReport,
          arguments: {
            'cycleId': widget.cycleId,
            'poolId': widget.poolId,
            'poolName': widget.poolName,
          },
        );
      },
      child: const Icon(Icons.add, color: Colors.white, size: 30),
    );
  }
}
