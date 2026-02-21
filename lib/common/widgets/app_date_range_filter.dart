import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppDateRangeFilter extends StatelessWidget {
  final Function(DateTime? start, DateTime? end) onFilter;
  final VoidCallback onReset;
  final DateTime? startDate;
  final DateTime? endDate;

  const AppDateRangeFilter({
    super.key,
    required this.onFilter,
    required this.onReset,
    this.startDate,
    this.endDate,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd-MM-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final String displayText = (startDate != null && endDate != null)
        ? '${_formatDate(startDate)} - ${_formatDate(endDate)}'
        : 'Pilih Rentang Tanggal';

    return GestureDetector(
      onTap: () async {
        final DateTimeRange? picked = await showDateRangePicker(
          context: context,
          initialDateRange: (startDate != null && endDate != null)
              ? DateTimeRange(start: startDate!, end: endDate!)
              : null,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                  primaryContainer: AppColors.primary,
                  onPrimaryContainer: Colors.white,
                ),
                datePickerTheme: const DatePickerThemeData(
                  rangePickerBackgroundColor: Colors.white,
                  rangeSelectionBackgroundColor: Color(0x332E358A),
                ),
              ),
              child: child!,
            );
          },
        );

        if (picked != null) {
          onFilter(picked.start, picked.end);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.gray, width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                displayText,
                style: TextStyle(
                  color: (startDate != null)
                      ? Colors.black
                      : AppColors.darkGray,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (startDate != null)
              GestureDetector(
                onTap: () {
                  onReset();
                },
                child: const Icon(
                  Icons.close,
                  size: 20,
                  color: AppColors.darkGray,
                ),
              )
            else
              Icon(
                Icons.calendar_today_outlined,
                size: 20,
                color: AppColors.darkGray,
              ),
          ],
        ),
      ),
    );
  }
}
