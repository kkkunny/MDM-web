import 'package:mdm/constants/strings.dart';

class FormatHelper {
  static String formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  static String formatSpeed(double bytesPerSecond) {
    if (bytesPerSecond < 1024) return '${bytesPerSecond.toStringAsFixed(0)} B';
    if (bytesPerSecond < 1024 * 1024) {
      return '${(bytesPerSecond / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytesPerSecond / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  static String formatDuration(Duration duration) {
    if (duration == Duration.zero) return AppStrings.zeroTime;
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return AppStrings.hoursMinutes
          .replaceAll('{}', hours.toString())
          .replaceAll('{}', minutes.toString());
    } else if (minutes > 0) {
      return AppStrings.minutesSeconds
          .replaceAll('{}', minutes.toString())
          .replaceAll('{}', seconds.toString());
    } else {
      return AppStrings.seconds.replaceAll('{}', seconds.toString());
    }
  }

  static String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return AppStrings.justNow;
    if (diff.inHours < 1) {
      return AppStrings.minutesAgo.replaceAll('{}', diff.inMinutes.toString());
    }
    if (diff.inDays < 1) {
      return AppStrings.hoursAgo.replaceAll('{}', diff.inHours.toString());
    }
    if (diff.inDays < 7) {
      return AppStrings.daysAgo.replaceAll('{}', diff.inDays.toString());
    }

    return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
  }

  static String formatProgress(double progress, double total) {
    if (total == 0) return '0.0%';
    final percentage = (progress / total * 100).clamp(0.0, 100.0);
    return '${percentage.toStringAsFixed(1)}%';
  }
}
