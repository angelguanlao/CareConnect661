/// Immutable data class representing a CareConnect user.
class UserModel {
  final String id;
  final String name;
  final String email;
  final DateTime joinDate;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.joinDate,
  });

  UserModel copyWith({String? name, String? email}) => UserModel(
        id: id,
        name: name ?? this.name,
        email: email ?? this.email,
        joinDate: joinDate,
      );

  /// Two-letter initials derived from the user's display name.
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
