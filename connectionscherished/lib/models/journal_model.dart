import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class JournalModel {
  String ? friendId = '';
  String ? journalId = '';
  String title = "Journal entry";
  String ? content;
  String ? notes;
  String ? mood;
  Timestamp entryTimestamp = Timestamp.now();

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
      friendId: data['friendId'] ?? '',
      journalId: data['journalId'] ?? '',
      title: data['title'] ?? "Journal entry",
      content: data['content'] ?? '',
      notes: data['notes'] ?? '',
      mood: data['mood'] ?? '',
      entryTimestamp: data['entryTimestamp'] ?? Timestamp.now(),
    );
  }

  JournalModel.fromJson(Map<String, dynamic> json) {
    friendId = json['friendId'] ?? '';
    journalId = json['journalId'] ?? '';
    title = json['title'] ?? "Journal entry";
    content = json['content'] ?? '';
    notes = json['notes'] ?? '';
    mood = json['mood'] ?? '';
    entryTimestamp = json['entryTimestamp'] ?? Timestamp.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'friendId': friendId,
      'journalId': journalId,
      'title': title,
      'content': content,
      'notes': notes,
      // ignore: collection_methods_unrelated_type
      'mood': mood,
      'entryTimestamp': entryTimestamp
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
