import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactHistoryModel {
  String ? friendId = '';
  String ? userId = '';
  String ? contactHistoryId = '';
  Timestamp lastContacted = Timestamp.now();

  ContactHistoryModel({
    this.friendId = '',
    this.userId = '',
    this.contactHistoryId = '',
    required this.lastContacted,
    // this.lastContactedDays = 0,
  });

  factory ContactHistoryModel.fromMap(Map<String, dynamic> data) {
    return ContactHistoryModel(
      friendId: data['friendId'] ?? '',
      userId: data['userId'] ?? '',
      contactHistoryId: data['contactHistoryId'] ?? '',
      lastContacted: data['lastContacted'] ?? Timestamp.now(),
      // lastContactedDays: data['lastContactedDays'] ?? 0
    );
  }

  ContactHistoryModel.fromJson(Map<String, dynamic> json) {
    friendId = json['friendId'] ?? '';
    userId = json['userId'] ?? '';
    contactHistoryId = json['contactHistoryId'] ?? '';
    lastContacted = json['lastContacted'] ?? Timestamp.now();
    // lastContactedDays = json['lastContactedDays'] ?? 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'friendId': friendId,
      'userId': userId,
      'contactHistoryId': contactHistoryId,
      'lastContacted': lastContacted,
      // 'lastContactedDays': lastContactedDays,
    };
  }

  String toJson() {
    return jsonEncode({
      ...toMap(),
    });
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
