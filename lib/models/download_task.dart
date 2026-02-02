enum TaskStatus {
  downloading,
  paused,
  completed,
  failed,
  waiting,
}

class DownloadTask {
  final String id;
  final String fileName;
  final String url;
  final int totalSize;
  final int downloadedSize;
  final double speed; // bytes per second
  final TaskStatus status;
  final DateTime createdAt;
  final String? category;
  final String? iconUrl;

  DownloadTask({
    required this.id,
    required this.fileName,
    required this.url,
    required this.totalSize,
    required this.downloadedSize,
    required this.speed,
    required this.status,
    required this.createdAt,
    this.category,
    this.iconUrl,
  });

  double get progress => totalSize > 0 ? downloadedSize / totalSize : 0;

  int get remainingSize => totalSize - downloadedSize;

  Duration get estimatedTime {
    if (speed <= 0) return Duration.zero;
    return Duration(seconds: (remainingSize / speed).round());
  }

  factory DownloadTask.fromJson(Map<String, dynamic> json) {
    return DownloadTask(
      id: json['id'],
      fileName: json['fileName'],
      url: json['url'],
      totalSize: json['totalSize'],
      downloadedSize: json['downloadedSize'],
      speed: (json['speed'] as num).toDouble(),
      status: TaskStatus.values.firstWhere(
            (e) => e.name == json['status'],
        orElse: () => TaskStatus.waiting,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      category: json['category'],
      iconUrl: json['iconUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fileName': fileName,
    'url': url,
    'totalSize': totalSize,
    'downloadedSize': downloadedSize,
    'speed': speed,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
    'category': category,
    'iconUrl': iconUrl,
  };

  DownloadTask copyWith({
    String? id,
    String? fileName,
    String? url,
    int? totalSize,
    int? downloadedSize,
    double? speed,
    TaskStatus? status,
    DateTime? createdAt,
    String? category,
    String? iconUrl,
  }) {
    return DownloadTask(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      url: url ?? this.url,
      totalSize: totalSize ?? this.totalSize,
      downloadedSize: downloadedSize ?? this.downloadedSize,
      speed: speed ?? this.speed,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }
}

class DownloadStats {
  final int totalTasks;
  final int downloading;
  final int completed;
  final int paused;
  final int failed;
  final double totalSpeed;
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

  factory DownloadStats.fromTasks(List<DownloadTask> tasks) {
    return DownloadStats(
      totalTasks: tasks.length,
      downloading: tasks.where((t) => t.status == TaskStatus.downloading).length,
      completed: tasks.where((t) => t.status == TaskStatus.completed).length,
      paused: tasks.where((t) => t.status == TaskStatus.paused).length,
      failed: tasks.where((t) => t.status == TaskStatus.failed).length,
      totalSpeed: tasks
          .where((t) => t.status == TaskStatus.downloading)
          .fold(0.0, (sum, t) => sum + t.speed),
      totalDownloaded: tasks.fold(0, (sum, t) => sum + t.downloadedSize),
      totalSize: tasks.fold(0, (sum, t) => sum + t.totalSize),
    );
  }
}