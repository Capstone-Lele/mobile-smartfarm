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

    // Prediksi panen menggunakan ADG (Average Daily Gain):
    // ADG = (berat_terakhir - berat_awal) / selisih_hari, lalu diekstrapolasi
    // secara linear dari sampel terakhir hingga mencapai target panen.
    const targetWeight = 750.0;
    const maxPredictionPoints = 20;

    final bool hasEnoughData = sortedReports.length >= 2;
    final predictedSpots = <FlSpot>[];
    final predictedDates = <DateTime>[];
    DateTime? estimatedHarvestDate;
    double adg = 0;
    String? predictionMessage;

    if (hasEnoughData) {
      final n = sortedReports.length;
      final firstWeight = actualSpots.first.y;
      final lastWeight = actualSpots.last.y;
      final totalDays = actualDates.last.difference(actualDates.first).inDays;

      if (totalDays <= 0) {
        predictionMessage =
            'Data sampling harus pada tanggal berbeda untuk prediksi.';
      } else {
        // ADG dalam gram per hari.
        adg = (lastWeight - firstWeight) / totalDays;

        if (lastWeight >= targetWeight) {
          // Target sudah tercapai pada sampel terakhir.
          estimatedHarvestDate = actualDates.last;
        } else if (adg <= 0) {
          predictionMessage =
              'Berat rata-rata tidak bertambah, estimasi panen belum tersedia.';
        } else {
          // Jarak hari antar titik prediksi mengikuti rata-rata interval sampling.
          final avgIntervalDays = (totalDays / (n - 1)).round().clamp(1, 30);

          // Sambungkan garis aktual terakhir dengan garis prediksi.
          predictedSpots.add(actualSpots.last);
          predictedDates.add(actualDates.last);

          for (int i = 1; i <= maxPredictionPoints; i++) {
            final x = (n - 1 + i).toDouble();
            final daysFromLast = avgIntervalDays * i;
            final yPred = lastWeight + adg * daysFromLast;
            final predDate = actualDates.last.add(
              Duration(days: daysFromLast),
            );

            predictedSpots.add(FlSpot(x, yPred));
            predictedDates.add(predDate);

            if (yPred >= targetWeight) break;
          }

          // Estimasi tanggal panen presisi berdasarkan ADG.
          final daysNeeded = ((targetWeight - lastWeight) / adg).ceil();
          estimatedHarvestDate = actualDates.last.add(
            Duration(days: daysNeeded),
          );
        }
      }
    }

    final bool canPredict = predictedSpots.isNotEmpty;

    final allSpots = [...actualSpots, ...predictedSpots];
    final allDates = [...actualDates, ...predictedDates.skip(1)]; // skip duplicate last actual date

    final double maxX = allSpots.isEmpty ? 0 : allSpots.map((s) => s.x).reduce((a, b) => a > b ? a : b);
    final double maxY = allSpots.isEmpty ? 0 : allSpots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final double yAxisMax = maxY > 750 ? maxY + 50 : 800.0;

    // Tampilkan maksimal ~6 label tanggal di sumbu X. Interval bulat agar label
    // hanya jatuh tepat pada indeks tertentu dan tidak saling menimpa.
    final int totalPoints = allDates.length;
    final int bottomInterval = totalPoints <= 6
        ? 1
        : (totalPoints / 6).ceil();

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
          if (!hasEnoughData)
            Text(
              'Butuh minimal 2 data untuk prediksi ADG. Saat ini: ${sortedReports.length} data.',
              style: const TextStyle(fontSize: 12, color: AppColors.red),
            )
          else if (estimatedHarvestDate != null) ...[
            Text(
              'Estimasi Panen: ${DateFormat('dd MMMM yyyy').format(estimatedHarvestDate)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.green,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'ADG (Average Daily Gain): ${adg.toStringAsFixed(1)} g/hari',
              style: const TextStyle(fontSize: 12, color: AppColors.darkGray),
            ),
          ] else
            Text(
              predictionMessage ?? 'Prediksi panen belum tersedia.',
              style: const TextStyle(fontSize: 12, color: AppColors.red),
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
                      reservedSize: 44,
                      interval: bottomInterval.toDouble(),
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        // Hanya render label pada indeks bulat yang tepat &
                        // yang jatuh pada kelipatan interval, agar tidak ada
                        // dua label berdempetan.
                        if (value != index.toDouble() ||
                            index < 0 ||
                            index >= allDates.length ||
                            index % bottomInterval != 0) {
                          return const SizedBox.shrink();
                        }
                        return SideTitleWidget(
                          meta: meta,
                          angle: -0.6,
                          space: 8,
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
