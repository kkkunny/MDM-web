import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/download_task.dart';
import '../services/download_service.dart';

enum FilterType { all, downloading, completed, paused, failed }

class TaskProvider extends ChangeNotifier {
  final DownloadService _service;

  List<DownloadTask> _tasks = [];
  bool _isLoading = false;
  String? _error;
  FilterType _currentFilter = FilterType.all;
  String _searchQuery = '';
  Set<String> _selectedTaskIds = {};
  StreamSubscription? _streamSubscription;

  TaskProvider({DownloadService? service})
      : _service = service ?? DownloadService();

  // Getters
  List<DownloadTask> get tasks => _filteredTasks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  FilterType get currentFilter => _currentFilter;
  String get searchQuery => _searchQuery;
  Set<String> get selectedTaskIds => _selectedTaskIds;
  bool get hasSelection => _selectedTaskIds.isNotEmpty;

  DownloadStats get stats => DownloadStats.fromTasks(_tasks);

  List<DownloadTask> get _filteredTasks {
    var filtered = _tasks;

    // 按状态过滤
    switch (_currentFilter) {
      case FilterType.downloading:
        filtered = filtered.where((t) =>
        t.status == TaskStatus.downloading ||
            t.status == TaskStatus.waiting
        ).toList();
        break;
      case FilterType.completed:
        filtered = filtered.where((t) => t.status == TaskStatus.completed).toList();
        break;
      case FilterType.paused:
        filtered = filtered.where((t) => t.status == TaskStatus.paused).toList();
        break;
      case FilterType.failed:
        filtered = filtered.where((t) => t.status == TaskStatus.failed).toList();
        break;
      case FilterType.all:
        break;
    }

    // 搜索过滤
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((t) =>
          t.fileName.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    return filtered;
  }

  /// 初始化并获取任务列表
  Future<void> initialize() async {
    await fetchTasks();
    _startRealtimeUpdates();
  }

  /// 获取任务列表
  Future<void> fetchTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = await _service.fetchTasks();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 开始实时更新
  void _startRealtimeUpdates() {
    _streamSubscription?.cancel();
    _streamSubscription = _service.getTasksStream().listen(
          (tasks) {
        _tasks = tasks;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        notifyListeners();
      },
    );
  }

  /// 添加新任务
  Future<void> addTask(String url, {String? fileName, String? category}) async {
    try {
      final task = await _service.addTask(
        url: url,
        fileName: fileName,
        category: category,
      );
      _tasks.insert(0, task);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// 暂停任务
  Future<void> pauseTask(String taskId) async {
    try {
      await _service.pauseTask(taskId);
      _updateTaskStatus(taskId, TaskStatus.paused);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// 继续任务
  Future<void> resumeTask(String taskId) async {
    try {
      await _service.resumeTask(taskId);
      _updateTaskStatus(taskId, TaskStatus.downloading);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// 删除任务
  Future<void> deleteTask(String taskId, {bool deleteFile = false}) async {
    try {
      await _service.deleteTask(taskId, deleteFile: deleteFile);
      _tasks.removeWhere((t) => t.id == taskId);
      _selectedTaskIds.remove(taskId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// 重试任务
  Future<void> retryTask(String taskId) async {
    try {
      await _service.retryTask(taskId);
      _updateTaskStatus(taskId, TaskStatus.downloading);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// 批量暂停
  Future<void> pauseSelected() async {
    await _service.batchOperation(
      taskIds: _selectedTaskIds.toList(),
      operation: 'pause',
    );
    for (var id in _selectedTaskIds) {
      _updateTaskStatus(id, TaskStatus.paused);
    }
    _selectedTaskIds.clear();
    notifyListeners();
  }

  /// 批量删除
  Future<void> deleteSelected({bool deleteFile = false}) async {
    await _service.batchOperation(
      taskIds: _selectedTaskIds.toList(),
      operation: 'delete',
    );
    _tasks.removeWhere((t) => _selectedTaskIds.contains(t.id));
    _selectedTaskIds.clear();
    notifyListeners();
  }

  void _updateTaskStatus(String taskId, TaskStatus status) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        status: status,
        speed: status == TaskStatus.paused ? 0 : _tasks[index].speed,
      );
      notifyListeners();
    }
  }

  /// 设置过滤器
  void setFilter(FilterType filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  /// 设置搜索关键词
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// 选择/取消选择任务
  void toggleSelection(String taskId) {
    if (_selectedTaskIds.contains(taskId)) {
      _selectedTaskIds.remove(taskId);
    } else {
      _selectedTaskIds.add(taskId);
    }
    notifyListeners();
  }

  /// 全选/取消全选
  void toggleSelectAll() {
    if (_selectedTaskIds.length == _filteredTasks.length) {
      _selectedTaskIds.clear();
    } else {
      _selectedTaskIds = _filteredTasks.map((t) => t.id).toSet();
    }
    notifyListeners();
  }

  /// 清除选择
  void clearSelection() {
    _selectedTaskIds.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _service.dispose();
    super.dispose();
  }
}