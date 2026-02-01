import 'package:budidaya_lele_mobile/features/schedule/domain/entities/schedule.dart';

enum DateComparison { past, today, upcoming }

extension DateTimeExtension on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);
}

extension ScheduleListExtension on List<Schedule> {
  List<Schedule> filterByDateComparison(
    DateTime today,
    DateComparison comparison,
  ) {
    return where((schedule) {
      final scheduleDay = schedule.scheduleDateParsed.dateOnly;
      return switch (comparison) {
        DateComparison.today => scheduleDay.compareTo(today) == 0,
        DateComparison.upcoming => scheduleDay.isAfter(today),
        DateComparison.past => scheduleDay.isBefore(today),
      };
    }).toList();
  }
}
