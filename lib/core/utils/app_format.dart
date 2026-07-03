import 'package:intl/intl.dart';

class AppFormat {
  static String date(String isoDate) {
    try {
      final date = DateTime.parse(isoDate).toLocal();
      final dayName = DateFormat('EEEE', 'id_ID').format(date);
      final formatted = DateFormat('d MMM yyyy', 'id_ID').format(date);
      return '$dayName, $formatted';
    } catch (e) {
      return isoDate;
    }
  }

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

  /// Format to API DateTime UTC: yyyy-MM-ddTHH:mm:ss.000Z
  static String toApiDateTime(String? uiDateTime) {
    if (uiDateTime == null || uiDateTime.isEmpty) return '';
    try {
      final localDate = DateFormat('dd-MM-yyyy HH:mm').parseStrict(uiDateTime);
      final utcDate = localDate.toUtc();
      return DateFormat("yyyy-MM-dd'T'HH:mm:ss.000'Z'").format(utcDate);
    } catch (e) {
      return uiDateTime;
    }
  }

  static String activityLog(String userName, String activity, String notes) {
    String activityLabel = activity.toLowerCase() == 'create'
        ? 'menambahkan'
        : 'memperbarui';

    String notesLabel = '';
    switch (notes.toLowerCase()) {
      case 'seed':
        notesLabel = 'tebar benih';
        break;
      case 'feed':
        notesLabel = 'pemberian pakan';
        break;
      case 'vitamin':
        notesLabel = 'pemberian vitamin';
        break;
      case 'sick':
        notesLabel = 'ikan sakit';
        break;
      case 'move pool':
        notesLabel = 'pindah kolam';
        break;
      case 'mortality':
        notesLabel = 'kematian ikan';
        break;
      case 'harvest':
        notesLabel = 'panen';
        break;
      case 'cleaning':
        notesLabel = 'pembersihan kolam';
        break;
      case 'sampling':
        notesLabel = 'sampling';
        break;
      case 'inventory':
        notesLabel = 'inventaris';
        break;
      default:
        notesLabel = notes;
    }

    return '$userName telah $activityLabel laporan $notesLabel';
  }
}
