import 'dart:convert';

class ContactHistoryModel {
  String ? friendId = '';
  String ? userId = '';
  String ? contactHistoryId = '';
  DateTime lastContacted = DateTime.now();

  ContactHistoryModel({
    this.friendId = '',
    this.userId = '',
    this.contactHistoryId = '',
    required this.lastContacted,
    // this.lastContactedDays = 0,
  });

  factory ContactHistoryModel.fromMap(Map<String, dynamic> data) {
    return ContactHistoryModel(
      friendId: data['friend_id'] ?? '',
      userId: data['user_id'] ?? '',
      contactHistoryId: data['contact_history_id'] ?? '',
      lastContacted: data['last_contacted'] !=null ? DateTime.parse(data['last_contacted']) : DateTime.now(),
      // lastContactedDays: data['lastContactedDays'] ?? 0
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'friend_id': friendId,
      'user_id': userId,
      'contact_history_id': contactHistoryId,
      'last_contacted': lastContacted.toIso8601String(),
      // 'lastContactedDays': lastContactedDays,
    };
  }

  Map<String, dynamic> insertMap() {
    return {
      'friend_id': friendId,
      'user_id': userId,
      'last_contacted': lastContacted.toIso8601String(),
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
