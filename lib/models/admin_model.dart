import 'package:equatable/equatable.dart';

/// The signed-in PRISM Team member. Used to render the sidebar profile
/// widget (avatar/initials + name + logout) and to gate admin routes.
class AdminModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role; // e.g. "Campaign Manager", "Founder"

  const AdminModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  /// Two-letter initials for the avatar, e.g. "Stone Circle" -> "SC".
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String? ?? 'Admin',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
      };

  @override
  List<Object?> get props => [id, name, email, role];
}
