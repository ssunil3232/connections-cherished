import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? userId;
  String userName;
  String profileImage = '';
  String email;
  Timestamp? createdAt;
  Timestamp? updatedAt;
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
      'userId': userId,
      'userName': userName,
      'email': email,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'profileImage': profileImage,
      'isDeleted': isDeleted,
      'enableNotifications': enableNotifications,
      'enableAi': enableAi,
      'message': message,
      'timezone': timezone
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      email: map['email'] ?? '',
      createdAt : map['createdAt'],
      updatedAt : map['updatedAt'],
      isDeleted: map['isDeleted'] ?? false,
      profileImage: map['profileImage']?? '',
      enableNotifications: map['enableNotifications'] ?? true,
      enableAi: map['enableAi'] ?? false,
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
