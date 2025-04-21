import 'dart:convert';

class JournalModel {
  String ? friendId = '';
  String ? journalId = '';
  String title = "Journal entry";
  String ? content;
  String ? notes;
  String ? mood;
  DateTime entryTimestamp = DateTime.now();

  JournalModel({
    this.friendId = '',
    this.journalId = '',
    title,
    this.content,
    this.notes,
    this.mood,
    required this.entryTimestamp,
  }) : title = title ?? "Journal entry";

  factory JournalModel.fromMap(Map<String, dynamic> data) {
    return JournalModel(
      friendId: data['friend_id'] ?? '',
      journalId: data['journal_id'] ?? '',
      title: data['title'] ?? "Journal entry",
      content: data['content'] ?? '',
      notes: data['notes'] ?? '',
      mood: data['mood'] ?? '',
      entryTimestamp: data['entry_timestamp'] != null ? DateTime.parse(data['entry_timestamp']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'friend_id': friendId,
      'journal_id': journalId,
      'title': title,
      'content': content,
      'notes': notes,
      // ignore: collection_methods_unrelated_type
      'mood': mood,
      'entry_timestamp': entryTimestamp.toIso8601String()
    };
  }

  Map<String, dynamic> insertMap() {
    return {
      'friend_id': friendId,
      'title': title,
      'content': content,
      'notes': notes,
      // ignore: collection_methods_unrelated_type
      'mood': mood,
      'entry_timestamp': entryTimestamp.toIso8601String()
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
