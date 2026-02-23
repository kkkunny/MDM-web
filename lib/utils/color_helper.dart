import 'package:flutter/material.dart';
import 'package:mdm/constants/colors.dart';
import 'package:mdm/models/vo/task.pb.dart';

class ColorHelper {
  static Color getStatusColor(TaskPhase status) {
    switch (status) {
      case TaskPhase.TpDownQueued:
        return AppColors.neutral;
      case TaskPhase.TpDownRunning:
        return AppColors.info;
      case TaskPhase.TpDownPaused:
        return AppColors.warning;
      case TaskPhase.TpDownFailed:
        return AppColors.error;
      case TaskPhase.TpDownCompleted:
        return AppColors.success;
      case TaskPhase.TpUpQueued:
        return AppColors.neutral;
      case TaskPhase.TpUpRunning:
        return AppColors.info;
      case TaskPhase.TpUpPaused:
        return AppColors.warning;
      case TaskPhase.TpUpFailed:
        return AppColors.error;
      case TaskPhase.TpUpCompleted:
        return AppColors.success;
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

  static LinearGradient getSurfaceGradient({bool isDark = true}) {
    if (isDark) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.surface, AppColors.surfaceLight],
      );
    } else {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.lightSurface, AppColors.lightSurfaceLight],
      );
    }
  }

  static LinearGradient getRunningGradient() {
    return const LinearGradient(colors: [AppColors.info, Color(0xFF44A08D)]);
  }
}
