
class UserModel {
  String? userId;
  String userName;
  String profileImage = '';
  String email;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool isDeleted = false;
  bool enableNotifications = true;
  bool enableAi = false;
  String message = 'Free for a quick catch up?';
  String timezone;

  UserModel({
      this.userId,
      this.userName = "",
      this.email = "",
      this.profileImage="",
      this.createdAt,
      this.updatedAt,
      this.isDeleted = false,
      this.enableNotifications = true,
      this.enableAi = false,
      this.message = 'Free for a quick catch up?',
      this.timezone = ""
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'user_name': userName,
      'email': email,
      'created_at': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      'profile_image': profileImage,
      'is_deleted': isDeleted,
      'enable_notifications': enableNotifications,
      'enable_ai': enableAi,
      'message': message,
      'timezone': timezone
    };
  }

  Map<String, dynamic> insertMap() {
    return {
      'user_id': userId,
      'user_name': userName,
      'email': email,
      'created_at': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      'profile_image': profileImage,
      'is_deleted': isDeleted,
      'enable_notifications': enableNotifications,
      'enable_ai': enableAi,
      'message': message,
      'timezone': timezone
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['user_id'] ?? '',
      userName: map['user_name'] ?? '',
      email: map['email'] ?? '',
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      isDeleted: map['is_deleted'] ?? false,
      profileImage: map['profile_image']?? '',
      enableNotifications: map['enable_notifications'] ?? true,
      enableAi: map['enable_ai'] ?? false,
      message: map['message'] ?? 'Free for a quick catch up?',
      timezone: map['timezone'] ?? ''
      );
  }

  @override
  String toString() {
    return 'UserModel(\n'
      '   userId: $userId,\n'
      '   userName: $userName,\n'
      '   email: $email,\n'
      '   profileImage: $profileImage,\n'
      '   isDeleted: $isDeleted,\n'
      '   enableNotifications: $enableNotifications\n'
      '   enableAi: $enableAi\n'
      '   message: $message\n'
      '   timezone: $timezone\n'
      ')';
  }
}
