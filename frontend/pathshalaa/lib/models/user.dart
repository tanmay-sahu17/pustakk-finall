class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final DateTime createdAt;
  final List<String> borrowedBookIds;
  final String? profileImageUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.createdAt,
    this.borrowedBookIds = const [],
    this.profileImageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: UserRole.values.firstWhere(
        (role) => role.name == json['role'],
        orElse: () => UserRole.member,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      borrowedBookIds: List<String>.from(json['borrowedBookIds'] ?? []),
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.name,
      'createdAt': createdAt.toIso8601String(),
      'borrowedBookIds': borrowedBookIds,
      'profileImageUrl': profileImageUrl,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    DateTime? createdAt,
    List<String>? borrowedBookIds,
    String? profileImageUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      borrowedBookIds: borrowedBookIds ?? this.borrowedBookIds,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}

enum UserRole { admin, librarian, member }

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Administrator';
      case UserRole.librarian:
        return 'Librarian';
      case UserRole.member:
        return 'Member';
    }
  }
}
