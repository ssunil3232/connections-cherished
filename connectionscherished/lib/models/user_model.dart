import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? userId;
  final String userName;
  String profileImage = '';
  String email;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  bool isDeleted = false;
  bool enableNotifications = true;

  UserModel({
      this.userId,
      this.userName = "",
      this.email = "",
      this.profileImage="",
      this.createdAt,
      this.updatedAt,
      this.isDeleted = false,
      this.enableNotifications = true
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
      'enableNotifications': enableNotifications
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
      enableNotifications: map['enableNotifications'] ?? true
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
      ')';
  }
}
