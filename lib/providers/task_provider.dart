import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mdm/apis/mdm/task.dart';
import 'package:mdm/constants/styles.dart';
import 'package:mdm/models/vo/task.pb.dart' hide DownloadStats;
import '../models/task.dart';
import '../services/download_service.dart';

enum FilterType { all, downloading, completed, paused, failed }

class TaskProvider extends ChangeNotifier {
  final DownloadService _service;

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;
  FilterType _currentFilter = FilterType.all;
  String _searchQuery = '';
  Set<String> _selectedTaskIds = {};
  StreamSubscription? _streamSubscription;

  TaskProvider({DownloadService? service})
    : _service = service ?? DownloadService();

  List<Task> get tasks => _filteredTasks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  FilterType get currentFilter => _currentFilter;
  String get searchQuery => _searchQuery;
  Set<String> get selectedTaskIds => _selectedTaskIds;
  bool get hasSelection => _selectedTaskIds.isNotEmpty;

  DownloadStats get stats => DownloadStats.fromTasks(_tasks);

  List<Task> get _filteredTasks {
    var filtered = _tasks;

    switch (_currentFilter) {
      case FilterType.downloading:
        filtered = filtered
            .where(
              (t) =>
                  t.phase == TaskPhase.TpDownRunning ||
                  t.phase == TaskPhase.TpDownQueued,
            )
            .toList();
        break;
      case FilterType.completed:
        filtered = filtered
            .where((t) => t.phase == TaskPhase.TpDownCompleted)
            .toList();
        break;
      case FilterType.paused:
        filtered = filtered
            .where((t) => t.phase == TaskPhase.TpDownPaused)
            .toList();
        break;
      case FilterType.failed:
        filtered = filtered
            .where((t) => t.phase == TaskPhase.TpDownFailed)
            .toList();
        break;
      case FilterType.all:
        break;
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (t) => t.name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    return filtered;
  }

  Future<void> initialize() async {
    await fetchTasks();
    _startRealtimeUpdates();
  }

  Future<void> fetchTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = (await listTasks()).tasks;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _startRealtimeUpdates() {
    _streamSubscription?.cancel();
    _streamSubscription =
        Stream.periodic(
          const Duration(seconds: AppStyles.refreshIntervalSeconds),
          (_) async => await listTasks(),
        ).listen(
          (resp) async {
            _tasks = (await resp).tasks;
            notifyListeners();
          },
          onError: (e) {
            _error = e.toString();
            notifyListeners();
          },
        );
  }

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

  Future<void> pauseTask(String taskId) async {
    try {
      await _service.pauseTask(taskId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> resumeTask(String taskId) async {
    try {
      await _service.resumeTask(taskId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

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

  Future<void> retryTask(String taskId) async {
    try {
      await _service.retryTask(taskId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> pauseSelected() async {
    await _service.batchOperation(
      taskIds: _selectedTaskIds.toList(),
      operation: 'pause',
    );
    _selectedTaskIds.clear();
    notifyListeners();
  }

  Future<void> deleteSelected({bool deleteFile = false}) async {
    await _service.batchOperation(
      taskIds: _selectedTaskIds.toList(),
      operation: 'delete',
    );
    _tasks.removeWhere((t) => _selectedTaskIds.contains(t.id));
    _selectedTaskIds.clear();
    notifyListeners();
  }

  void setFilter(FilterType filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleSelection(String taskId) {
    if (_selectedTaskIds.contains(taskId)) {
      _selectedTaskIds.remove(taskId);
    } else {
      _selectedTaskIds.add(taskId);
    }
    notifyListeners();
  }

  void toggleSelectAll() {
    if (_selectedTaskIds.length == _filteredTasks.length) {
      _selectedTaskIds.clear();
    } else {
      _selectedTaskIds = _filteredTasks.map((t) => t.id).toSet();
    }
    notifyListeners();
  }

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
