import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/task.dart';

class TasksProvider extends ChangeNotifier {  // Changé: 'with' -> 'extends'
  final DatabaseReference _db = FirebaseDatabase.instanceFor(
    app: FirebaseAuth.instance.app,
    databaseURL: "https://coachlink-6ba3f-default-rtdb.firebaseio.com/",
  ).ref();

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String get currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> loadTasks({String? sessionId}) async {
    if (currentUserId.isEmpty) return;
    _isLoading = true;
    notifyListeners();

    final snapshot = await _db
        .child('tasks')
        .orderByChild('userId')
        .equalTo(currentUserId)
        .once();

    _tasks = [];
    if (snapshot.snapshot.value != null) {
      final Map raw = snapshot.snapshot.value as Map;
      _tasks = raw.entries.map((entry) {
        return Task.fromMap(
          Map<String, dynamic>.from(entry.value as Map),
          entry.key as String,
        );
      }).toList();
    }

    if (sessionId != null) {
      _tasks = _tasks.where((t) => t.sessionId == sessionId).toList();
    }
    _tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    final newRef = _db.child('tasks').push();
    await newRef.set(task.toMap());
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await _db.child('tasks/${task.id}').update(task.toMap());
    await loadTasks();
  }

  Future<void> deleteTask(String taskId) async {
    await _db.child('tasks/$taskId').remove();
    await loadTasks();
  }

  Future<void> toggleComplete(String taskId) async {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    final updated = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      isCompleted: !task.isCompleted,
      sessionId: task.sessionId,
      userId: task.userId,
    );
    await updateTask(updated);
  }
}