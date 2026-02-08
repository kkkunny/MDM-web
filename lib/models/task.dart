import 'package:mdm/models/vo/task.pb.dart';

extension TaskPhaseExtension on TaskPhase {
  String get label {
    switch (this) {
      case TaskPhase.TpDownWaiting:
        return '等待中';
      case TaskPhase.TpDownRunning:
        return '下载中';
      case TaskPhase.TpDownPaused:
        return '已暂停';
      case TaskPhase.TpDownFailed:
        return '已失败';
      case TaskPhase.TpDownCompleted:
        return '已完成';
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
      paused: tasks.where((t) => t.phase == TaskPhase.TpDownWaiting).length,
      failed: tasks.where((t) => t.phase == TaskPhase.TpDownFailed).length,
      totalSpeed: tasks
          .where((t) => t.phase == TaskPhase.TpDownRunning)
          .fold(0, (sum, t) => sum + t.downloadStats.speed.toInt()),
      totalDownloaded: tasks.fold(0, (sum, t) => sum + t.downloadStats.progress.toInt()),
      totalSize: tasks.fold(0, (sum, t) => sum + t.size.toInt()),
    );
  }
}