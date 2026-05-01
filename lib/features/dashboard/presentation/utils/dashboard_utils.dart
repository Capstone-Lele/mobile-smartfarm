import 'package:flutter/material.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_status_badge.dart';

enum ParamStatus { normal, warning, danger }

class DashboardUtils {
  static ParamStatus getParamStatus(
    double value,
    List<double> minRange,
    List<double> normalRange,
    List<double> maxRange,
  ) {
    if (normalRange.isNotEmpty) {
      double normMin = normalRange.first;
      double normMax = normalRange.last;
      if (value >= normMin && value <= normMax) {
        return ParamStatus.normal;
      }
    }

    double overallMin =
        minRange.isNotEmpty ? minRange.first : double.negativeInfinity;
    double overallMax =
        maxRange.isNotEmpty ? maxRange.last : double.infinity;

    if (value >= overallMin && value <= overallMax) {
      return ParamStatus.warning;
    }

    return ParamStatus.danger;
  }

  static Color getStatusColor(ParamStatus status) {
    switch (status) {
      case ParamStatus.normal:
        return AppColors.green;
      case ParamStatus.warning:
        return AppColors.yellow;
      case ParamStatus.danger:
        return AppColors.red;
    }
  }

  static BadgeType getBadgeType(ParamStatus status) {
    switch (status) {
      case ParamStatus.normal:
        return BadgeType.success;
      case ParamStatus.warning:
        return BadgeType.warning;
      case ParamStatus.danger:
        return BadgeType.danger;
    }
  }

  static String getStatusLabel(ParamStatus status) {
    switch (status) {
      case ParamStatus.normal:
        return 'Normal';
      case ParamStatus.warning:
        return 'Peringatan';
      case ParamStatus.danger:
        return 'Bahaya';
    }
  }

  static ParamStatus getOverallStatus(
      ParamStatus tempStatus, ParamStatus phStatus) {
    if (tempStatus == ParamStatus.danger || phStatus == ParamStatus.danger) {
      return ParamStatus.danger;
    }
    if (tempStatus == ParamStatus.warning || phStatus == ParamStatus.warning) {
      return ParamStatus.warning;
    }
    return ParamStatus.normal;
  }
}
