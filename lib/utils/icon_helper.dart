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
}
