class AppUser {
  final int id;
  final String name;
  final String email;
  final String createdAt;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      createdAt: map['createdAt'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email, 'createdAt': createdAt};
  }
}
