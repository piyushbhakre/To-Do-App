import 'package:dio/dio.dart';
import 'package:herody_assignment/core/services/auth_service.dart';
import 'package:herody_assignment/features/home/task_model.dart';
import 'package:herody_assignment/firebase_options.dart';

class TaskApiService {
  TaskApiService({
    Dio? dio,
    AuthService? authService,
  })  : _dio = dio ?? Dio(),
        _authService = authService ?? AuthService();

  final Dio _dio;
  final AuthService _authService;

  String get _databaseUrl {
    final url = DefaultFirebaseOptions.currentPlatform.databaseURL;
    if (url == null || url.isEmpty) {
      throw StateError(
        'Realtime Database URL is missing in firebase_options.dart',
      );
    }
    return url;
  }

  Future<({String userId, Map<String, dynamic> query})> _authContext() async {
    final user = _authService.currentUser;
    if (user == null) {
      throw StateError('User is not logged in.');
    }

    final token = await user.getIdToken();
    final query = <String, dynamic>{};
    if (token != null && token.isNotEmpty) {
      query['auth'] = token;
    }

    return (userId: user.uid, query: query);
  }

  Future<List<TaskModel>> fetchTasks() async {
    final context = await _authContext();
    final response = await _dio.get<Map<String, dynamic>?>(
      '$_databaseUrl/tasks/${context.userId}.json',
      queryParameters: context.query,
    );

    final data = response.data;
    if (data == null) {
      return const [];
    }

    final tasks = data.entries
        .map(
          (entry) => TaskModel.fromMap(
            id: entry.key,
            map: (entry.value as Map).cast<String, dynamic>(),
          ),
        )
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return tasks;
  }

  Future<TaskModel> addTask({
    required String title,
    required String description,
  }) async {
    final context = await _authContext();
    final now = DateTime.now().toUtc().toIso8601String();

    final payload = <String, dynamic>{
      'title': title.trim(),
      'description': description.trim(),
      'isCompleted': false,
      'createdAt': now,
      'updatedAt': now,
    };

    final response = await _dio.post<Map<String, dynamic>>(
      '$_databaseUrl/tasks/${context.userId}.json',
      data: payload,
      queryParameters: context.query,
    );

    final taskId = response.data?['name'] as String?;
    if (taskId == null || taskId.isEmpty) {
      throw StateError('Failed to create task.');
    }

    return TaskModel.fromMap(id: taskId, map: payload);
  }

  Future<void> updateTask({
    required String taskId,
    required String title,
    required String description,
  }) async {
    final context = await _authContext();
    final payload = <String, dynamic>{
      'title': title.trim(),
      'description': description.trim(),
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
    };

    await _dio.patch<void>(
      '$_databaseUrl/tasks/${context.userId}/$taskId.json',
      data: payload,
      queryParameters: context.query,
    );
  }

  Future<void> toggleTaskCompletion({
    required String taskId,
    required bool isCompleted,
  }) async {
    final context = await _authContext();
    final payload = <String, dynamic>{
      'isCompleted': isCompleted,
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
    };

    await _dio.patch<void>(
      '$_databaseUrl/tasks/${context.userId}/$taskId.json',
      data: payload,
      queryParameters: context.query,
    );
  }

  Future<void> deleteTask(String taskId) async {
    final context = await _authContext();
    await _dio.delete<void>(
      '$_databaseUrl/tasks/${context.userId}/$taskId.json',
      queryParameters: context.query,
    );
  }
}
