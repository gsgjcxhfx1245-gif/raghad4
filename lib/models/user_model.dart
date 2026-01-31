class User {
  int id;
  String name;
  String email;
  String password;
  String profileImage;
  DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.profileImage,
    required this.createdAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      profileImage: map['profile_image'] ?? '👤',
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'profile_image': profileImage,
      'created_at': createdAt.toIso8601String(),
    };
  }
}