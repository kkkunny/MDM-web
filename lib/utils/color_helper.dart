import 'package:flutter/material.dart';
import 'package:mdm/constants/colors.dart';
import 'package:mdm/models/vo/task.pb.dart';

class ColorHelper {
  static Color getStatusColor(TaskPhase status) {
    switch (status) {
      case TaskPhase.TpDownRunning:
        return AppColors.info;
      case TaskPhase.TpDownCompleted:
        return AppColors.success;
      case TaskPhase.TpDownPaused:
        return AppColors.warning;
      case TaskPhase.TpDownFailed:
        return AppColors.error;
      case TaskPhase.TpDownWaiting:
        return AppColors.neutral;
      default:
        return AppColors.neutral;
    }
  }

  static Color getStatusBackgroundColor(TaskPhase status) {
    return getStatusColor(status).withValues(alpha: 0.1);
  }

  static Color getStatusBorderColor(TaskPhase status) {
    return getStatusColor(status).withValues(alpha: 0.3);
  }

  static LinearGradient getPrimaryGradient() {
    return const LinearGradient(
      colors: [AppColors.gradientStart, AppColors.gradientEnd],
    );
  }

  static LinearGradient getSurfaceGradient() {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.surface, AppColors.surfaceLight],
    );
  }

  static LinearGradient getRunningGradient() {
    return const LinearGradient(colors: [AppColors.info, Color(0xFF44A08D)]);
  }
}
