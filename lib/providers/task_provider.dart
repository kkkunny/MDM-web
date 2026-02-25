import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mdm/apis/mdm/task.dart';
import 'package:mdm/constants/styles.dart';
import 'package:mdm/models/vo/task.pb.dart' hide DownloadStats;
import '../models/task.dart';
import '../services/download_service.dart';

enum FilterType {
  DL_running, DL_completed, DL_paused, DL_failed,
  UL_running, UL_completed, UL_paused, UL_failed,
}

class TaskProvider extends ChangeNotifier {
  final DownloadService _service;

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;
  FilterType _currentFilter = FilterType.DL_running;
  String _searchQuery = '';
  Set<String> _selectedTaskIds = {};
  StreamSubscription? _streamSubscription;
  int _currentPage = 1;
  bool _hasMore = false;
  bool _isLoadingMore = false;
  static const int _pageSize = 20;

  TaskProvider({DownloadService? service})
    : _service = service ?? DownloadService();

  List<Task> get tasks => _filteredTasks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  FilterType get currentFilter => _currentFilter;
  String get searchQuery => _searchQuery;
  Set<String> get selectedTaskIds => _selectedTaskIds;
  bool get hasSelection => _selectedTaskIds.isNotEmpty;
  int get currentPage => _currentPage;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
  bool get canLoadMore => _hasMore && !_isLoadingMore;

  DownloadStats get stats => DownloadStats.fromTasks(_tasks);

  List<Task> get _filteredTasks {
    var filtered = _tasks;

    switch (_currentFilter) {
      case FilterType.DL_running:
        filtered = filtered
            .where(
              (t) =>
                  t.phase == TaskPhase.TpDownRunning ||
                  t.phase == TaskPhase.TpDownQueued,
            )
            .toList();
        break;
      case FilterType.DL_completed:
        filtered = filtered
            .where((t) => t.phase == TaskPhase.TpDownCompleted)
            .toList();
        break;
      case FilterType.DL_paused:
        filtered = filtered
            .where((t) => t.phase == TaskPhase.TpDownPaused)
            .toList();
        break;
      case FilterType.DL_failed:
        filtered = filtered
            .where((t) => t.phase == TaskPhase.TpDownFailed)
            .toList();
        break;
      case FilterType.UL_running:
        filtered = filtered
            .where(
              (t) =>
          t.phase == TaskPhase.TpUpRunning ||
              t.phase == TaskPhase.TpUpQueued,
        )
            .toList();
        break;
      case FilterType.UL_completed:
        filtered = filtered
            .where((t) => t.phase == TaskPhase.TpUpCompleted)
            .toList();
        break;
      case FilterType.UL_paused:
        filtered = filtered
            .where((t) => t.phase == TaskPhase.TpUpPaused)
            .toList();
        break;
      case FilterType.UL_failed:
        filtered = filtered
            .where((t) => t.phase == TaskPhase.TpUpFailed)
            .toList();
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
    _currentPage = 1;
    notifyListeners();

    try {
      final response = await listTasks(page: 1, count: _pageSize);
      _tasks = response.tasks;
      _hasMore = response.hasMore;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final response = await listTasks(page: nextPage, count: _pageSize);
      _tasks.addAll(response.tasks);
      _currentPage = nextPage;
      _hasMore = response.hasMore;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void _startRealtimeUpdates() {
    _streamSubscription?.cancel();
    _streamSubscription =
        Stream.periodic(
          const Duration(seconds: AppStyles.refreshIntervalSeconds),
          (_) => listTasks(page: _currentPage, count: _pageSize),
        ).listen(
          (futureResp) async {
            final resp = await futureResp;
            _tasks = resp.tasks;
            _hasMore = resp.hasMore;
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
    _currentPage = 1;
    fetchTasks();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _currentPage = 1;
    fetchTasks();
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
