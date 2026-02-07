import 'dart:async';
import 'package:fixnum/fixnum.dart';
import 'package:http/http.dart' as http;
import 'package:mdm/models/vo/task.pb.dart';

/// 下载服务 - 预留网络请求接口
class DownloadService {
  static const String baseUrl = 'YOUR_API_BASE_URL';

  final http.Client _client;

  DownloadService({http.Client? client}) : _client = client ?? http.Client();

  /// 添加新下载任务
  Future<Task> addTask({
    required String url,
    String? fileName,
    String? category,
  }) async {
    // TODO: 替换为实际API调用
    // final response = await _client.post(
    //   Uri.parse('$baseUrl/tasks'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: json.encode({
    //     'url': url,
    //     'fileName': fileName,
    //     'category': category,
    //   }),
    // );
    //
    // if (response.statusCode == 201) {
    //   return DownloadTask.fromJson(json.decode(response.body));
    // }
    // throw Exception('Failed to add task');

    await Future.delayed(const Duration(milliseconds: 300));
    return Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: fileName ?? 'new_file.zip',
      size: Int64(1024 * 1024 * 100),
      downloadStats: DownloadStats(
        speed: Int64(1),
        progress: Int64(0),
      ),
      phase: TaskPhase.TpDownWaiting,
      createdAt: Int64(DateTime.now().second),
      category: Category(name: category ?? ''),
    );
  }

  /// 暂停任务
  Future<bool> pauseTask(String taskId) async {
    // TODO: 替换为实际API调用
    // final response = await _client.post(
    //   Uri.parse('$baseUrl/tasks/$taskId/pause'),
    // );
    // return response.statusCode == 200;

    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  /// 继续任务
  Future<bool> resumeTask(String taskId) async {
    // TODO: 替换为实际API调用
    // final response = await _client.post(
    //   Uri.parse('$baseUrl/tasks/$taskId/resume'),
    // );
    // return response.statusCode == 200;

    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  /// 删除任务
  Future<bool> deleteTask(String taskId, {bool deleteFile = false}) async {
    // TODO: 替换为实际API调用
    // final response = await _client.delete(
    //   Uri.parse('$baseUrl/tasks/$taskId'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: json.encode({'deleteFile': deleteFile}),
    // );
    // return response.statusCode == 200;

    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  /// 重试失败任务
  Future<bool> retryTask(String taskId) async {
    // TODO: 替换为实际API调用
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  /// 批量操作
  Future<bool> batchOperation({
    required List<String> taskIds,
    required String operation, // pause, resume, delete
  }) async {
    // TODO: 替换为实际API调用
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  /// 生成模拟数据
  List<Task> _generateMockTasks() {
    final now = DateTime.now();
    return [
      Task(
        id: '1',
        name: 'Flutter_SDK_3.16.0.zip',
          size: Int64(1024 * 1024 * 850),
        downloadStats: DownloadStats(
          speed: Int64((1024 * 1024 * 2.5).toInt()),
          progress: Int64((1024 * 1024 * 850 * 0.67).round()),
        ),
        phase: TaskPhase.TpDownRunning,
        createdAt: Int64(now.subtract(const Duration(minutes: 30)).second),
        category: Category(name: 'Development'),
      ),
      Task(
        id: '2',
        name: 'VS_Code_Setup.exe',
    size: Int64(1024 * 1024 * 95),
        downloadStats: DownloadStats(
          speed: Int64((1024 * 1024 * 1.8).toInt()),
          progress: Int64((1024 * 1024 * 95 * 0.45).round()),
        ),
        phase: TaskPhase.TpDownRunning,
        createdAt: Int64(now.subtract(const Duration(minutes: 15)).second),
        category: Category(name: 'Development'),
      ),
      Task(
        id: '3',
        name: 'Ubuntu_22.04_LTS.iso',
    size: Int64(1024 * 1024 * 1024 * 4),
        downloadStats: DownloadStats(
          speed: Int64(0),
          progress: Int64((1024 * 1024 * 1024 * 4 * 0.23).round()),
        ),
        phase: TaskPhase.TpDownRunning,
        createdAt: Int64(now.subtract(const Duration(hours: 1)).second),
        category: Category(name: 'OS'),
      ),
      Task(
        id: '4',
        name: 'Android_Studio.dmg',
    size: Int64(1024 * 1024 * 920),
        downloadStats: DownloadStats(
          speed: Int64(0),
          progress: Int64(1024 * 1024 * 920),
        ),
        phase: TaskPhase.TpDownCompleted,
        createdAt: Int64(now.subtract(const Duration(hours: 2)).second),
        category: Category(name: 'Development'),
      ),
      Task(
        id: '5',
        name: 'NodeJS_v20.10.0.pkg',
    size: Int64(1024 * 1024 * 45),
        downloadStats: DownloadStats(
          speed: Int64(0),
          progress: Int64((1024 * 1024 * 45 * 0.8).round()),
        ),
        phase: TaskPhase.TpDownPaused,
        createdAt: Int64(now.subtract(const Duration(hours: 3)).second),
        category: Category(name: 'Development'),
      ),
      Task(
        id: '6',
        name: 'Docker_Desktop.exe',
    size: Int64(1024 * 1024 * 580),
        downloadStats: DownloadStats(
          speed: Int64(0),
          progress: Int64((1024 * 1024 * 580 * 0.12).round()),
        ),
        phase: TaskPhase.TpDownFailed,
        createdAt: Int64(now.subtract(const Duration(hours: 4)).second),
        category: Category(name: 'Development'),
      ),
      Task(
        id: '7',
        name: 'Figma_Desktop.dmg',
    size: Int64(1024 * 1024 * 250),
        downloadStats: DownloadStats(
          speed: Int64(0),
          progress: Int64(1024 * 1024 * 250),
        ),
        phase: TaskPhase.TpDownCompleted,
        createdAt: Int64(now.subtract(const Duration(days: 1)).second),
        category: Category(name: 'Design'),
      ),
      Task(
        id: '8',
        name: 'Postman_Agent.zip',
        downloadStats: DownloadStats(
          speed: Int64(0),
          progress: Int64(0),
        ),
        size: Int64(1024 * 1024 * 180),
        phase: TaskPhase.TpDownWaiting,
        createdAt: Int64(now.second),
        category: Category(name: 'Development'),
      ),
    ];
  }

  void dispose() {
    _client.close();
  }
}