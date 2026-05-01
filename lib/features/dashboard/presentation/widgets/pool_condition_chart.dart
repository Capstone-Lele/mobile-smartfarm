import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/entities/chart_iots.dart';
import 'package:budidaya_lele_mobile/features/dashboard/presentation/providers/iot_provider.dart';
import 'package:intl/intl.dart';

class PoolConditionChart extends ConsumerWidget {
  final DateTime? startDate;
  final DateTime? endDate;

  const PoolConditionChart({
    super.key,
    this.startDate,
    this.endDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartAsync = ref.watch(chartIotsNotifierProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Grafik Sensor Kolam',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend('pH Kolam', AppColors.primary),
              const SizedBox(width: 16),
              _buildLegend('Suhu (°C)', AppColors.secondary),
            ],
          ),
          const SizedBox(height: 16),
          chartAsync.when(
            loading: () => const SizedBox(
              height: 240,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 3,
                ),
              ),
            ),
            error: (error, stack) => const SizedBox(
              height: 240,
              child: Center(
                child: Text(
                  'Gagal memuat data grafik',
                  style: TextStyle(color: AppColors.darkGray, fontSize: 14),
                ),
              ),
            ),
            data: (chartData) {
              if (startDate == null || endDate == null) {
                return const SizedBox(
                  height: 240,
                  child: Center(
                    child: Text(
                      'Pilih rentang tanggal untuk\nmelihat grafik sensor',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.darkGray,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }
              if (chartData.isEmpty) {
                return const SizedBox(
                  height: 240,
                  child: Center(
                    child: Text(
                      'Tidak ada data pada rentang\ntanggal yang dipilih',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.darkGray,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }
              return _buildChart(chartData, startDate!, endDate!);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChart(
    List<ChartIots> chartData,
    DateTime startDate,
    DateTime endDate,
  ) {
    // Buat list tanggal sesuai rentang
    // final totalDays = endDate.difference(startDate).inDays + 1;

    // Hitung interval x-axis (tampilkan maks 7 label)
    final int xCount = chartData.length;
    final int labelInterval = (xCount / 7).ceil().clamp(1, xCount);

    // Map data ke FlSpot berdasarkan index
    final phSpots = <FlSpot>[];
    final tempSpots = <FlSpot>[];

    for (int i = 0; i < chartData.length; i++) {
      final ph = double.tryParse(chartData[i].ph) ?? 0.0;
      final temp = double.tryParse(chartData[i].temp) ?? 0.0;
      phSpots.add(FlSpot(i.toDouble(), ph));
      tempSpots.add(FlSpot(i.toDouble(), temp));
    }

    // Tanggal untuk label x-axis
    final dates = chartData
        .map((e) {
          try {
            return DateTime.parse(e.createdAt);
          } catch (_) {
            return startDate;
          }
        })
        .toList();

    final dateFormatter = DateFormat('dd/MM');

    return SizedBox(
      height: 240,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: AppColors.gray.withValues(alpha: 0.5),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: labelInterval.toDouble(),
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= dates.length) {
                    return const SizedBox.shrink();
                  }
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      dateFormatter.format(dates[index]),
                      style: const TextStyle(
                        fontSize: 9,
                        color: AppColors.darkGray,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 5,
                reservedSize: 30,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.darkGray,
                    ),
                  ),
                ),
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (xCount - 1).toDouble(),
          minY: 0,
          maxY: 45,
          lineBarsData: [
            _buildLineBarData(phSpots, AppColors.primary),
            _buildLineBarData(tempSpots, AppColors.secondary),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  LineChartBarData _buildLineBarData(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: false,
      color: color,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 4,
          color: color,
          strokeWidth: 2,
          strokeColor: Colors.white,
        ),
      ),
      belowBarData: BarAreaData(show: false),
    );
  }
}
