import 'package:budidaya_lele_mobile/features/schedule/domain/entities/schedule.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/schedule_summary.dart';
import 'package:budidaya_lele_mobile/features/schedule/domain/entities/grouped_schedules.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/providers/feeding_provider.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/providers/sampling_provider.dart';
import 'package:budidaya_lele_mobile/features/schedule/presentation/utils/schedule_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'cleaning_provider.dart';

final scheduleTabProvider = StateProvider<int>((ref) => 0);

final activeScheduleProvider = Provider<AsyncValue<List<Schedule>>>((ref) {
  final selectedTab = ref.watch(scheduleTabProvider);
  return switch (selectedTab) {
    0 => ref.watch(cleaningListNotifierProvider),
    1 => ref.watch(feedingListNotifierProvider),
    2 => ref.watch(samplingListNotifierProvider),
    _ => const AsyncValue.data(<Schedule>[]),
  };
});

final scheduleSummaryProvider = Provider<AsyncValue<ScheduleSummary>>((ref) {
  final scheduleAsync = ref.watch(activeScheduleProvider);
  return scheduleAsync.when(
    data: (schedules) {
      final now = DateTime.now();
      final today = now.dateOnly;

      final todayCount = schedules
          .where((s) => s.scheduleDateParsed.dateOnly.compareTo(today) == 0)
          .length;

      final upcomingCount = schedules
          .where((s) => s.scheduleDateParsed.isAfter(now))
          .length;

      return AsyncValue.data(
        ScheduleSummary(
          total: schedules.length,
          today: todayCount,
          upcoming: upcomingCount,
        ),
      );
    },
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
});

final groupedSchedulesProvider = Provider<AsyncValue<GroupedSchedules>>((ref) {
  final scheduleAsync = ref.watch(activeScheduleProvider);
  return scheduleAsync.when(
    data: (schedules) {
      final now = DateTime.now();
      final today = now.dateOnly;

      final todaySchedules = schedules.filterByDateComparison(
        today,
        DateComparison.today,
      );
      final upcomingSchedules = schedules.filterByDateComparison(
        today,
        DateComparison.upcoming,
      );
      final pastSchedules = schedules.filterByDateComparison(
        today,
        DateComparison.past,
      );

      return AsyncValue.data(
        GroupedSchedules(
          today: todaySchedules,
          upcoming: upcomingSchedules,
          past: pastSchedules,
        ),
      );
    },
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
});

final scheduleContentProvider = Provider<AsyncValue<GroupedSchedules>>((ref) {
  final scheduleAsync = ref.watch(activeScheduleProvider);

  return scheduleAsync.when(
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
    data: (schedules) {
      if (schedules.isEmpty) {
        return AsyncValue.data(
          GroupedSchedules(today: [], upcoming: [], past: []),
        );
      }
      return ref.watch(groupedSchedulesProvider);
    },
  );
});
