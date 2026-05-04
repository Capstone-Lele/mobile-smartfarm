import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/entities/sampling_report.dart';

class SamplingPredictionChart extends StatelessWidget {
  final List<SamplingReport> reports;

  const SamplingPredictionChart({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      return const SizedBox.shrink();
    }

    // Urutkan data berdasarkan tanggal (paling lama ke terbaru)
    final sortedReports = List<SamplingReport>.from(reports)
      ..sort((a, b) => a.reportDate.compareTo(b.reportDate));

    final actualSpots = <FlSpot>[];
    final actualDates = <DateTime>[];

    for (int i = 0; i < sortedReports.length; i++) {
      final report = sortedReports[i];
      final weight = double.tryParse(report.averageWeight) ?? 0.0;
      actualSpots.add(FlSpot(i.toDouble(), weight));
      actualDates.add(DateTime.tryParse(report.reportDate) ?? DateTime.now());
    }

    // Hitung regresi linear jika data >= 3
    final bool canPredict = sortedReports.length >= 3;
    final predictedSpots = <FlSpot>[];
    final predictedDates = <DateTime>[];
    DateTime? estimatedHarvestDate;

    if (canPredict) {
      final n = sortedReports.length;
      double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;

      for (int i = 0; i < n; i++) {
        final x = i.toDouble();
        final y = actualSpots[i].y;
        sumX += x;
        sumY += y;
        sumXY += x * y;
        sumX2 += x * x;
      }

      final slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
      final intercept = (sumY - slope * sumX) / n;

      // Hitung rata-rata interval hari
      final totalDays = actualDates.last.difference(actualDates.first).inDays;
      final avgIntervalDays = (totalDays / (n - 1)).round().clamp(1, 30); // Minimal 1 hari

      const targetWeight = 750.0;
      const maxPredictionPoints = 20;

      // Hubungkan garis aktual terakhir dengan garis prediksi pertama
      predictedSpots.add(actualSpots.last);
      predictedDates.add(actualDates.last);

      for (int i = 1; i <= maxPredictionPoints; i++) {
        final x = (n - 1 + i).toDouble();
        final yPred = slope * x + intercept;
        final predDate = actualDates.last.add(Duration(days: avgIntervalDays * i));

        predictedSpots.add(FlSpot(x, yPred));
        predictedDates.add(predDate);

        if (yPred >= targetWeight) {
          estimatedHarvestDate = predDate;
          break;
        }
      }
    }

    final allSpots = [...actualSpots, ...predictedSpots];
    final allDates = [...actualDates, ...predictedDates.skip(1)]; // skip duplicate last actual date

    final double maxX = allSpots.isEmpty ? 0 : allSpots.map((s) => s.x).reduce((a, b) => a > b ? a : b);
    final double maxY = allSpots.isEmpty ? 0 : allSpots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final double yAxisMax = maxY > 750 ? maxY + 50 : 800.0;

    final dateFormatter = DateFormat('dd/MM');

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
            'Grafik Prediksi Panen',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 8),
          if (canPredict && estimatedHarvestDate != null)
            Text(
              'Estimasi Panen: ${DateFormat('dd MMMM yyyy').format(estimatedHarvestDate)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.green,
              ),
            )
          else if (canPredict)
            const Text(
              'Target panen (750g) belum tercapai dalam horizon prediksi.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.red,
              ),
            )
          else
            Text(
              'Butuh minimal 3 data untuk prediksi. Saat ini: ${sortedReports.length} data.',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.red,
              ),
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend('Aktual (g)', AppColors.primary),
              const SizedBox(width: 12),
              if (canPredict) _buildLegend('Prediksi (g)', AppColors.secondary),
              const SizedBox(width: 12),
              _buildLegend('Target (750g)', AppColors.red),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 240,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.gray.withValues(alpha: 0.5),
                    strokeWidth: 1,
                    dashArray: value == 750 ? [4, 4] : null,
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
                      interval: (maxX / 5).ceilToDouble().clamp(1.0, maxX > 0 ? maxX : 1.0),
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= allDates.length) {
                          return const SizedBox.shrink();
                        }
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            dateFormatter.format(allDates[index]),
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
                      interval: 150,
                      reservedSize: 35,
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
                maxX: maxX,
                minY: 0,
                maxY: yAxisMax,
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: 750,
                      color: AppColors.red,
                      strokeWidth: 1,
                      dashArray: [4, 4],
                      label: HorizontalLineLabel(
                        show: true,
                        alignment: Alignment.topRight,
                        padding: const EdgeInsets.only(right: 4, bottom: 4),
                        style: const TextStyle(fontSize: 9, color: AppColors.red),
                        labelResolver: (line) => 'Target',
                      ),
                    ),
                  ],
                ),
                lineBarsData: [
                  _buildLineBarData(actualSpots, AppColors.primary),
                  if (canPredict)
                    _buildLineBarData(predictedSpots, AppColors.secondary, isDashed: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.darkGray,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  LineChartBarData _buildLineBarData(List<FlSpot> spots, Color color, {bool isDashed = false}) {
    return LineChartBarData(
      spots: spots,
      isCurved: false,
      color: color,
      barWidth: 2,
      isStrokeCapRound: true,
      dashArray: isDashed ? [4, 4] : null,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 3,
          color: color,
          strokeWidth: 1.5,
          strokeColor: Colors.white,
        ),
      ),
      belowBarData: BarAreaData(show: false),
    );
  }
}
