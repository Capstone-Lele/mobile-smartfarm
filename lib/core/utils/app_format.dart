import 'package:intl/intl.dart';

class AppFormat {
  static String dateTime(String isoDate) {
    try {
      final date = DateTime.parse(isoDate).toLocal();
      final dayName = DateFormat('EEEE', 'id_ID').format(date);
      final formatted = DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(date);
      return '$dayName, $formatted';
    } catch (e) {
      return isoDate;
    }
  }

  static String currentDateTime() {
    final now = DateTime.now();
    final dayName = DateFormat('EEEE', 'id_ID').format(now);
    final formatted = DateFormat('d MMMM yyyy HH:mm', 'id_ID').format(now);
    return '$dayName, $formatted';
  }

  /// Format to UI Date: dd-MM-yyyy
  static String toUiDate(String? apiDate) {
    if (apiDate == null || apiDate.isEmpty) return '';
    try {
      final date = DateTime.parse(apiDate).toLocal();
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (e) {
      return apiDate;
    }
  }

  /// Format to UI DateTime: dd-MM-yyyy HH:mm
  static String toUiDateTime(String? apiDateTime) {
    if (apiDateTime == null || apiDateTime.isEmpty) return '';
    try {
      final date = DateTime.parse(apiDateTime).toLocal();
      return DateFormat('dd-MM-yyyy HH:mm').format(date);
    } catch (e) {
      return apiDateTime;
    }
  }

  /// Format to API Date: yyyy-MM-dd
  static String toApiDate(String? uiDate) {
    if (uiDate == null || uiDate.isEmpty) return '';
    try {
      final date = DateFormat('dd-MM-yyyy').parse(uiDate);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      return uiDate;
    }
  }

  /// Format to API DateTime: yyyy-MM-dd HH:mm:ss
  static String toApiDateTime(String? uiDateTime) {
    if (uiDateTime == null || uiDateTime.isEmpty) return '';
    try {
      final date = DateFormat('dd-MM-yyyy HH:mm').parse(uiDateTime);
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
    } catch (e) {
      return uiDateTime;
    }
  }
}
