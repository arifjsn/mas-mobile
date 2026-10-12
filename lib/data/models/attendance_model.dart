class AttendanceModel {
  final int id;
  final int userId;
  final String username;
  final String role;
  final String type; // 'in' or 'out'
  final String photoPath;
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? notes;
  final String createdAt;

  AttendanceModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.role,
    required this.type,
    required this.photoPath,
    this.latitude,
    this.longitude,
    this.address,
    this.notes,
    required this.createdAt,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      userId: json['user_id'] is int ? json['user_id'] : int.parse(json['user_id'].toString()),
      username: json['username'] ?? '',
      role: json['role'] ?? 'staff',
      type: json['type'] ?? 'in',
      photoPath: json['photo_path'] ?? '',
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      address: json['address'],
      notes: json['notes'],
      createdAt: json['created_at'] ?? '',
    );
  }
}
