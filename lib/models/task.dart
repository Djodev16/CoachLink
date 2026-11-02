class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final String? sessionId; // optionnel : lier à une séance spécifique
  final String userId;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.sessionId,
    required this.userId,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'dueDate': dueDate.millisecondsSinceEpoch,
    'isCompleted': isCompleted,
    'sessionId': sessionId,
    'userId': userId,
  };

  factory Task.fromMap(Map<String, dynamic> map, String id) => Task(
    id: id,
    title: map['title'] ?? '',
    description: map['description'] ?? '',
    dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate']),
    isCompleted: map['isCompleted'] ?? false,
    sessionId: map['sessionId'],
    userId: map['userId'] ?? '',
  );
}