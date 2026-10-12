class UserModel {
  final int id;
  final String username;
  final String? email;
  final String role;
  final int? companyId;
  final String? companyName;
  final String? avatarPath;

  UserModel({
    required this.id,
    required this.username,
    this.email,
    required this.role,
    this.companyId,
    this.companyName,
    this.avatarPath,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      username: json['username'] ?? '',
      email: json['email'],
      role: json['role'] ?? 'user',
      companyId: json['company_id'] != null ? int.tryParse(json['company_id'].toString()) : null,
      companyName: json['company_name'],
      avatarPath: json['avatar_path'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'role': role,
    'company_id': companyId,
    'company_name': companyName,
    'avatar_path': avatarPath,
  };
}
