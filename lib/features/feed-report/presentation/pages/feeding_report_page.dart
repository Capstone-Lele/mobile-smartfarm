import 'package:budidaya_lele_mobile/common/widgets/app_date_range_filter.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_hint_board.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:flutter/material.dart';

class FeedingReportPage extends StatefulWidget {
  final String cycleId;
  final String poolId;
  final String poolName;

  const FeedingReportPage({
    super.key,
    required this.cycleId,
    required this.poolId,
    required this.poolName,
  });

  @override
  State<FeedingReportPage> createState() => _FeedingReportPageState();
}

class _FeedingReportPageState extends State<FeedingReportPage> {
  DateTime? _startDate;
  DateTime? _endDate;

  final List<Map<String, dynamic>> _feedingReports = [
    {
      'id': 1,
      'title': 'Laporan Pakan Kolam #1',
      'product': 'Pelet A1',
      'date': 'Senin, 29 September 2025 08.30',
      'quantity': 5,
      'image': 'https://picsum.photos/200',
    },
    {
      'id': 2,
      'title': 'Laporan Pakan Kolam #2',
      'product': 'Pelet B2',
      'date': 'Senin, 29 September 2025 16.30',
      'quantity': 4,
      'image': 'https://picsum.photos/201',
    },
    {
      'id': 3,
      'title': 'Laporan Pakan Kolam #3',
      'product': 'Pelet A1',
      'date': 'Selasa, 30 September 2025 08.30',
      'quantity': 6,
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
                const AppHintBoard(
                  title: '📌 Petunjuk Laporan Pakan',
                  desc:
                      '• Tekan + untuk tambah laporan kalau anda melakukan pemberian pakan.\n• Ketuk laporan untuk lihat detailnya.',
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _feedingReports.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final report = _feedingReports[index];
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
            'Daftar Laporan Pakan',
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
          AppRoutes.feedingReportDetail,
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
                  color: AppColors.lightGray,
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
                        'Produk: ${report['product']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.darkGray,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Jumlah : ${report['quantity']} KG',
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
          AppRoutes.createFeedingReport,
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
