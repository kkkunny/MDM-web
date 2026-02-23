import 'dart:async';
import 'package:fixnum/fixnum.dart';
import 'package:http/http.dart' as http;
import 'package:mdm/models/vo/task.pb.dart';

class DownloadService {
  static const String baseUrl = 'YOUR_API_BASE_URL';

  final http.Client _client;

  DownloadService({http.Client? client}) : _client = client ?? http.Client();

  Future<Task> addTask({
    required String url,
    String? fileName,
    String? category,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: fileName ?? 'new_file.zip',
      size: Int64(1024 * 1024 * 100),
      downloadStats: DownloadStats(speed: Int64(1), size: Int64(0)),
      phase: TaskPhase.TpDownQueued,
      createdAt: Int64(DateTime.now().second),
      category: Category(name: category ?? ''),
    );
  }

  Future<bool> pauseTask(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Future<bool> resumeTask(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Future<bool> deleteTask(String taskId, {bool deleteFile = false}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Future<bool> retryTask(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Future<bool> batchOperation({
    required List<String> taskIds,
    required String operation,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  void dispose() {
    _client.close();
  }
}
