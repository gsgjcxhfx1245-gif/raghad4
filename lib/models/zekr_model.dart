class Zekr {
  int id;
  String content;
  int importance;
  String? imagePath;
  String? category;
  DateTime createdAt;
  int userId;

  Zekr({
    required this.id,
    required this.content,
    required this.importance,
    this.imagePath,
    this.category,
    required this.createdAt,
    required this.userId,
  });

  factory Zekr.fromMap(Map<String, dynamic> map) {
    return Zekr(
      id: map['id'] ?? 0,
      content: map['content'] ?? '',
      importance: map['importance'] ?? 3,
      imagePath: map['image_path'],
      category: map['category'],
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      userId: map['user_id'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'importance': importance,
      'image_path': imagePath,
      'category': category,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
    };
  }
}