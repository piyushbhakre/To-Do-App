import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:herody_assignment/core/services/auth_service.dart';
import 'package:herody_assignment/core/services/task_api_service.dart';
import 'package:herody_assignment/core/services/user_profile_service.dart';
import 'package:herody_assignment/features/home/model.dart';
import 'package:herody_assignment/features/home/task_model.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    AuthService? authService,
    UserProfileService? userProfileService,
    TaskApiService? taskApiService,
  })  : _authService = authService ?? AuthService(),
        _userProfileService = userProfileService ?? UserProfileService(),
        _taskApiService = taskApiService ?? TaskApiService();

  final AuthService _authService;
  final UserProfileService _userProfileService;
  final TaskApiService _taskApiService;

  HomeModel? _user;
  List<TaskModel> _tasks = const [];
  bool _isProfileLoading = false;
  bool _isTaskLoading = false;
  bool _isActionInProgress = false;
  String? _profileErrorMessage;
  String? _taskErrorMessage;

  HomeModel? get user => _user;
  List<TaskModel> get tasks => _tasks;
  bool get isProfileLoading => _isProfileLoading;
  bool get isTaskLoading => _isTaskLoading;
  bool get isActionInProgress => _isActionInProgress;
  String? get profileErrorMessage => _profileErrorMessage;
  String? get taskErrorMessage => _taskErrorMessage;

  Future<void> initialize() async {
    await Future.wait([
      loadCurrentUserDetails(),
      fetchTasks(),
    ]);
  }

  Future<HomeModel?> loadCurrentUserDetails() async {
    _isProfileLoading = true;
    _profileErrorMessage = null;
    notifyListeners();

    final user = _authService.currentUser;
    if (user == null) {
      _user = null;
      _isProfileLoading = false;
      _profileErrorMessage = 'No logged in user found.';
      notifyListeners();
      return null;
    }

    try {
      final map = await _userProfileService.getUserProfile(user.uid);
      if (map == null) {
        _user = HomeModel(
          uid: user.uid,
          email: user.email ?? '-',
          username: '-',
          encryptedPassword: '-',
        );
      } else {
        _user = HomeModel.fromMap(map);
      }
    } catch (error) {
      _profileErrorMessage = _mapError(error);
      _user = HomeModel(
        uid: user.uid,
        email: user.email ?? '-',
        username: '-',
        encryptedPassword: '-',
      );
    } finally {
      _isProfileLoading = false;
      notifyListeners();
    }

    return _user;
  }

  Future<void> fetchTasks() async {
    _isTaskLoading = true;
    _taskErrorMessage = null;
    notifyListeners();

    try {
      _tasks = await _taskApiService.fetchTasks();
    } catch (error) {
      _taskErrorMessage = _mapError(error);
    } finally {
      _isTaskLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask({
    required String title,
    required String description,
  }) async {
    if (title.trim().isEmpty) {
      _taskErrorMessage = 'Task title is required.';
      notifyListeners();
      return;
    }

    _isActionInProgress = true;
    _taskErrorMessage = null;
    notifyListeners();

    try {
      final createdTask = await _taskApiService.addTask(
        title: title,
        description: description,
      );
      _tasks = [createdTask, ..._tasks];
    } catch (error) {
      _taskErrorMessage = _mapError(error);
    } finally {
      _isActionInProgress = false;
      notifyListeners();
    }
  }

  Future<void> editTask({
    required String taskId,
    required String title,
    required String description,
  }) async {
    if (title.trim().isEmpty) {
      _taskErrorMessage = 'Task title is required.';
      notifyListeners();
      return;
    }

    _isActionInProgress = true;
    _taskErrorMessage = null;
    notifyListeners();

    try {
      await _taskApiService.updateTask(
        taskId: taskId,
        title: title,
        description: description,
      );
      final now = DateTime.now().toUtc().toIso8601String();
      _tasks = _tasks
          .map(
            (task) => task.id == taskId
                ? task.copyWith(
                    title: title.trim(),
                    description: description.trim(),
                    updatedAt: now,
                  )
                : task,
          )
          .toList();
    } catch (error) {
      _taskErrorMessage = _mapError(error);
    } finally {
      _isActionInProgress = false;
      notifyListeners();
    }
  }

  Future<void> toggleTask(TaskModel task) async {
    _isActionInProgress = true;
    _taskErrorMessage = null;
    notifyListeners();

    final updatedCompletion = !task.isCompleted;

    try {
      await _taskApiService.toggleTaskCompletion(
        taskId: task.id,
        isCompleted: updatedCompletion,
      );
      final now = DateTime.now().toUtc().toIso8601String();
      _tasks = _tasks
          .map(
            (value) => value.id == task.id
                ? value.copyWith(
                    isCompleted: updatedCompletion,
                    updatedAt: now,
                  )
                : value,
          )
          .toList();
    } catch (error) {
      _taskErrorMessage = _mapError(error);
    } finally {
      _isActionInProgress = false;
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId) async {
    _isActionInProgress = true;
    _taskErrorMessage = null;
    notifyListeners();

    try {
      await _taskApiService.deleteTask(taskId);
      _tasks = _tasks.where((task) => task.id != taskId).toList();
    } catch (error) {
      _taskErrorMessage = _mapError(error);
    } finally {
      _isActionInProgress = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  String _mapError(Object error) {
    if (error is DioException) {
      if (error.response?.statusCode == 401) {
        return 'Authorization failed. Please login again.';
      }
      return error.message ?? 'Network error. Please try again.';
    }
    if (error is StateError) {
      return error.message;
    }
    return 'Something went wrong. Please try again.';
  }
}
