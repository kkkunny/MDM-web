import 'package:mdm/models/vo/task.pb.dart';

extension TaskPhaseExtension on TaskPhase {
  String get label {
    switch (this) {
      case TaskPhase.TpDownQueued:
        return '等待下载';
      case TaskPhase.TpDownRunning:
        return '下载中';
      case TaskPhase.TpDownPaused:
        return '暂停下载';
      case TaskPhase.TpDownFailed:
        return '下载失败';
      case TaskPhase.TpDownCompleted:
        return '下载完成';
      case TaskPhase.TpUpQueued:
        return '等待上传';
      case TaskPhase.TpUpRunning:
        return '上传中';
      case TaskPhase.TpUpPaused:
        return '暂停上传';
      case TaskPhase.TpUpFailed:
        return '上传失败';
      case TaskPhase.TpUpCompleted:
        return '上传完成';
      default:
        return 'Unknown';
    }
  }
}

extension TaskExtension on Task {

}

class DownloadStats {
  final int totalTasks;
  final int downloading;
  final int completed;
  final int paused;
  final int failed;
  final int totalSpeed;
  final int totalDownloaded;
  final int totalSize;

  DownloadStats({
    required this.totalTasks,
    required this.downloading,
    required this.completed,
    required this.paused,
    required this.failed,
    required this.totalSpeed,
    required this.totalDownloaded,
    required this.totalSize,
  });

  factory DownloadStats.fromTasks(List<Task> tasks) {
    return DownloadStats(
      totalTasks: tasks.length,
      downloading: tasks.where((t) => t.phase == TaskPhase.TpDownRunning).length,
      completed: tasks.where((t) => t.phase == TaskPhase.TpDownCompleted).length,
      paused: tasks.where((t) => t.phase == TaskPhase.TpDownQueued).length,
      failed: tasks.where((t) => t.phase == TaskPhase.TpDownFailed).length,
      totalSpeed: tasks
          .where((t) => t.phase == TaskPhase.TpDownRunning)
          .fold(0, (sum, t) => sum + t.downloadStats.speed.toInt()),
      totalDownloaded: tasks.fold(0, (sum, t) => sum + t.downloadStats.size.toInt()),
      totalSize: tasks.fold(0, (sum, t) => sum + t.size.toInt()),
    );
  }
}