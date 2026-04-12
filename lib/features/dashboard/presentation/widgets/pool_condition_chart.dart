import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';

class PoolConditionChart extends StatelessWidget {
  const PoolConditionChart({super.key});

  @override
  Widget build(BuildContext context) {
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
            'Data Sensor',
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
                      interval: 1,
                      getTitlesWidget: bottomTitleWidgets,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      getTitlesWidget: leftTitleWidgets,
                      reservedSize: 30,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 45,
                lineBarsData: [
                  _buildLineBarData([
                    const FlSpot(0, 7.2),
                    const FlSpot(1, 6.8),
                    const FlSpot(2, 7.5),
                    const FlSpot(3, 7.0),
                    const FlSpot(4, 7.6),
                    const FlSpot(5, 6.9),
                    const FlSpot(6, 7.4),
                  ], AppColors.primary),
                  _buildLineBarData([
                    const FlSpot(0, 35),
                    const FlSpot(1, 37),
                    const FlSpot(2, 34),
                    const FlSpot(3, 38),
                    const FlSpot(4, 36),
                    const FlSpot(5, 39),
                    const FlSpot(6, 35),
                  ], AppColors.secondary),
                ],
              ),
            ),
          ),
        ],
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

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10, color: AppColors.darkGray);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Senin';
        break;
      case 1:
        text = 'Selasa';
        break;
      case 2:
        text = 'Rabu';
        break;
      case 3:
        text = 'Kamis';
        break;
      case 4:
        text = 'Jumat';
        break;
      case 5:
        text = 'Sabtu';
        break;
      case 6:
        text = 'Minggu';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      meta: meta,
      child: Text(text, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10, color: AppColors.darkGray);
    return SideTitleWidget(
      meta: meta,
      child: Text(value.toInt().toString(), style: style),
    );
  }
}
