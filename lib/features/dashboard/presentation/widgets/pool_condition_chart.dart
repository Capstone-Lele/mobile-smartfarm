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

  const PoolConditionChart({super.key, this.startDate, this.endDate});

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
            error: (error, stack) {
              return SizedBox(
                height: 240,
                child: Center(
                  child: Text(
                    'Gagal memuat data grafik',
                    style: TextStyle(color: AppColors.darkGray, fontSize: 14),
                  ),
                ),
              );
            },
            data: (chartData) {
              if (startDate == null || endDate == null) {
                return const SizedBox(
                  height: 240,
                  child: Center(
                    child: Text(
                      'Pilih rentang tanggal untuk\nmelihat grafik sensor',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.darkGray, fontSize: 14),
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
                      style: TextStyle(color: AppColors.darkGray, fontSize: 14),
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
    // 1. Group and average data by day.
    final Map<String, List<ChartIots>> groupedData = {};
    for (var item in chartData) {
      try {
        final dateStr = item.createdAt.substring(0, 10); // YYYY-MM-DD
        groupedData.putIfAbsent(dateStr, () => []).add(item);
      } catch (_) {
        continue;
      }
    }

    final sortedKeys = groupedData.keys.toList()..sort();

    // 2. Map data to FlSpot using day offset from startDate.
    final phSpots = <FlSpot>[];
    final tempSpots = <FlSpot>[];

    for (var dateKey in sortedKeys) {
      final date = DateTime.parse(dateKey);
      final offset = date.difference(startDate).inDays.toDouble();

      final items = groupedData[dateKey]!;
      final avgPh =
          items.map((e) => e.ph).reduce((a, b) => a + b) / items.length;
      final avgTemp =
          items.map((e) => e.temp).reduce((a, b) => a + b) / items.length;

      phSpots.add(FlSpot(offset, avgPh));
      tempSpots.add(FlSpot(offset, avgTemp));
    }

    final totalDays = endDate.difference(startDate).inDays.toDouble();
    final maxX = totalDays > 0 ? totalDays : 1.0;

    // Interval tanggal adaptif: target ~4-6 label agar tidak terlalu padat
    // maupun terlalu jarang. Makin panjang rentang, makin renggang ticknya.
    double xInterval;
    if (totalDays <= 7) {
      xInterval = 1; // harian
    } else if (totalDays <= 14) {
      xInterval = 2;
    } else if (totalDays <= 31) {
      xInterval = 7; // mingguan
    } else if (totalDays <= 90) {
      xInterval = 14;
    } else {
      xInterval = 30; // bulanan
    }

    final dateFormatter = DateFormat('dd/MM');

    // Skala Y menampung kedua seri (pH & Suhu) sekaligus, dibulatkan rapi.
    final allValues = [...phSpots.map((e) => e.y), ...tempSpots.map((e) => e.y)];
    final minData = allValues.reduce((a, b) => a < b ? a : b);
    final maxData = allValues.reduce((a, b) => a > b ? a : b);
    var minY = ((minData - 2) / 5).floorToDouble() * 5;
    var maxY = ((maxData + 2) / 5).ceilToDouble() * 5;
    if (minY < 0) minY = 0;
    if (maxY <= minY) maxY = minY + 5;
    final yInterval = ((maxY - minY) / 5).ceilToDouble();

    return SizedBox(
      height: 240,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: yInterval,
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
                interval: xInterval,
                getTitlesWidget: (value, meta) {
                  // Render label tanggal berkala selama masih dalam rentang.
                  if (value < 0 || value > totalDays) {
                    return const SizedBox.shrink();
                  }
                  final date = startDate.add(Duration(days: value.toInt()));
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      dateFormatter.format(date),
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
                interval: yInterval,
                reservedSize: 34,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(
                    value.toStringAsFixed(0),
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
          clipData: const FlClipData.all(),
          minX: 0,
          maxX: maxX,
          minY: minY,
          maxY: maxY,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => AppColors.black.withValues(alpha: 0.8),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final isPh = spot.barIndex == 0;
                  final label = isPh ? 'pH' : 'Suhu';
                  final unit = isPh ? '' : '°C';
                  return LineTooltipItem(
                    '$label: ${spot.y.toStringAsFixed(1)}$unit',
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
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
      isCurved: true,
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
