import 'package:budidaya_lele_mobile/features/schedule/domain/entities/schedule.dart';

class GroupedSchedules {
  final List<Schedule> today;
  final List<Schedule> upcoming;
  final List<Schedule> past;

  GroupedSchedules({
    required this.today,
    required this.upcoming,
    required this.past,
  });

  bool get isEmpty => today.isEmpty && upcoming.isEmpty && past.isEmpty;
}
