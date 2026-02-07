import 'package:flutter/material.dart';
import 'package:mdm/constants/colors.dart';
import 'package:mdm/providers/task_provider.dart';

class IconHelper {
  static IconData getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'zip':
      case 'rar':
      case '7z':
      case 'tar':
      case 'gz':
        return Icons.folder_zip_rounded;
      case 'exe':
      case 'dmg':
      case 'pkg':
      case 'msi':
        return Icons.install_desktop_rounded;
      case 'iso':
        return Icons.album_rounded;
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'mp4':
      case 'mkv':
      case 'avi':
      case 'mov':
        return Icons.video_file_rounded;
      case 'mp3':
      case 'wav':
      case 'flac':
        return Icons.audio_file_rounded;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
        return Icons.image_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  static IconData getFilterIcon(FilterType filter) {
    switch (filter) {
      case FilterType.all:
        return Icons.list_rounded;
      case FilterType.downloading:
        return Icons.download_rounded;
      case FilterType.completed:
        return Icons.check_circle_rounded;
      case FilterType.paused:
        return Icons.pause_circle_rounded;
      case FilterType.failed:
        return Icons.error_rounded;
    }
  }

  static String getFilterLabel(FilterType filter) {
    switch (filter) {
      case FilterType.all:
        return 'All Tasks';
      case FilterType.downloading:
        return 'Downloading';
      case FilterType.completed:
        return 'Completed';
      case FilterType.paused:
        return 'Paused';
      case FilterType.failed:
        return 'Failed';
    }
  }

  static Color getFilterColor(FilterType filter) {
    switch (filter) {
      case FilterType.all:
        return AppColors.white;
      case FilterType.downloading:
        return AppColors.info;
      case FilterType.completed:
        return AppColors.success;
      case FilterType.paused:
        return AppColors.warning;
      case FilterType.failed:
        return AppColors.error;
    }
  }
}
