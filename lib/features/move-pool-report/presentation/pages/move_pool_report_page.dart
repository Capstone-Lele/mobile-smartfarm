import 'package:budidaya_lele_mobile/common/widgets/app_date_range_filter.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_hint_board.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_loading.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_format.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/user/domain/entities/user.dart';
import 'package:budidaya_lele_mobile/features/user/presentation/providers/user_provider.dart';
import 'package:budidaya_lele_mobile/features/move-pool-report/domain/entities/move_pool_report.dart';
import 'package:budidaya_lele_mobile/features/move-pool-report/presentation/providers/move_pool_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovePoolReportPage extends ConsumerStatefulWidget {
  final String cycleId;
  final bool isCycle;
  final String poolId;
  final String poolName;

  const MovePoolReportPage({
    super.key,
    required this.cycleId,
    required this.isCycle,
    required this.poolId,
    required this.poolName,
  });

  @override
  ConsumerState<MovePoolReportPage> createState() => _MovePoolReportPageState();
}

class _MovePoolReportPageState extends ConsumerState<MovePoolReportPage> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(movePoolReportListNotifierProvider.notifier)
          .getMovePoolReports(widget.poolId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final reportState = ref.watch(movePoolReportListNotifierProvider);

    return Scaffold(
      appBar: _buildHeader(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref
                .read(movePoolReportListNotifierProvider.notifier)
                .getMovePoolReports(widget.poolId);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                AppHintBoard(
                  title: '📌 Petunjuk Laporan Pindah Kolam',
                  desc: user?.role != 'pic'
                      ? '• Tekan + untuk tambah laporan kalau anda melakukan pindah kolam.\n• Ketuk laporan untuk lihat detailnya.'
                      : '• Ketuk laporan untuk lihat detailnya.',
                ),
                const SizedBox(height: 16),
                reportState.when(
                  loading: () => _buildSummaryCardsLoading(user),
                  error: (error, stack) => Center(
                    child: Text(
                      error.toString(),
                      style: const TextStyle(color: AppColors.red),
                    ),
                  ),
                  data: (data) => _buildSummaryCards(data, user),
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
                reportState.when(
                  loading: () => ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        AppLoading(height: 100, borderRadius: 8),
                  ),
                  error: (error, stack) => Center(
                    child: Text(
                      error.toString(),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  data: (data) {
                    final filteredData = data.where((report) {
                      if (_startDate != null && _endDate != null) {
                        try {
                          final parsed = DateTime.parse(report.reportDate);
                          final dateOnly = DateTime(
                            parsed.year,
                            parsed.month,
                            parsed.day,
                          );
                          final start = DateTime(
                            _startDate!.year,
                            _startDate!.month,
                            _startDate!.day,
                          );
                          final end = DateTime(
                            _endDate!.year,
                            _endDate!.month,
                            _endDate!.day,
                          );
                          if (dateOnly.isBefore(start) ||
                              dateOnly.isAfter(end)) {
                            return false;
                          }
                        } catch (e) {
                          return false;
                        }
                      }
                      return true;
                    }).toList();

                    if (filteredData.isEmpty) {
                      return _buildEmptyReports();
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredData.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final report = filteredData[index];
                        return _buildReportItem(report, index, user);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(user),
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
            'Daftar Laporan Pindah Kolam',
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

  Widget _buildEmptyReports() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 80, color: AppColors.darkGray),
            const SizedBox(height: 16),
            const Text(
              'Belum ada laporan pindah kolam.',
              style: TextStyle(color: AppColors.darkGray, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportItem(MovePoolReport report, int index, User? user) {
    final formattedDate = AppFormat.dateTime(report.reportDate);

    return GestureDetector(
      onTap: () {
        AppRoutes.pushNamed(
          context,
          AppRoutes.movePoolReportDetail,
          arguments: {
            'reportId': report.id,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    report.image,
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
                        'Laporan Pindah Kolam #${index + 1}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Jumlah Ikan yang Dipindah ${report.quantity} Ekor',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.darkGray,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.darkGray,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Kolam Asal ${report.originPoolName}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.darkGray,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Kolam Tujuan ${report.destinationPoolName}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.darkGray,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (user?.role == 'pic') ...[
              const SizedBox(height: 12),
              Text(
                'Dilaporkan Oleh ${report.user}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.darkGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCardsLoading(User? user) {
    if (user?.role == 'pic') {
      return IntrinsicHeight(
        child: Row(
          children: [
            Expanded(child: AppLoading(height: 100, borderRadius: 12)),
            const SizedBox(width: 8),
            Expanded(child: AppLoading(height: 100, borderRadius: 12)),
            const SizedBox(width: 8),
            Expanded(child: AppLoading(height: 100, borderRadius: 12)),
          ],
        ),
      );
    } else {
      return AppLoading(height: 50, borderRadius: 12);
    }
  }

  Widget _buildSummaryCards(List<MovePoolReport> reports, User? user) {
    final total = reports.length;
    final lastQuantity = reports.isNotEmpty ? reports.first.quantity : 0;

    if (user?.role == 'pic') {
      return IntrinsicHeight(
        child: Row(
          children: [
            Expanded(child: _buildTotalReportCard(total)),
            const SizedBox(width: 8),
            Expanded(child: _buildLastQuantityCard(lastQuantity)),
            const SizedBox(width: 8),
            Expanded(child: _buildSiklusCard()),
          ],
        ),
      );
    } else {
      return _buildSiklusFullCard();
    }
  }

  Widget _buildTotalReportCard(int total) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.darkGray),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$total',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.article, size: 22, color: Colors.black),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Total Laporan',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLastQuantityCard(int quantity) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.darkGray),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$quantity',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Terakhir Jumlah Ikan Pindah',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSiklusCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.darkGray),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Siklus Sedang Aktif',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Icon(
            widget.isCycle ? Icons.check : Icons.close,
            color: widget.isCycle ? AppColors.green : AppColors.red,
            size: 28,
          ),
        ],
      ),
    );
  }

  Widget _buildSiklusFullCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.darkGray),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Siklus Sedang Aktif',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            widget.isCycle ? Icons.check : Icons.close,
            color: widget.isCycle ? AppColors.green : AppColors.red,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(User? user) {
    if (user?.role != 'pic' && widget.isCycle) {
      return FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: AppColors.secondary,
        onPressed: () {
          AppRoutes.pushNamed(
            context,
            AppRoutes.createMovePoolReport,
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
    return const SizedBox.shrink();
  }
}
