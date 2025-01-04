import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectionscherished/styles/styles.dart';

class PeriodicAlert {
  int years = 0;
  int months = 0;
  int days = 1;

  PeriodicAlert({
    required this.years, required this.months, required this.days
  });

  PeriodicAlert.empty();

  PeriodicAlert.fromJson(Map<String, dynamic> json) {
    years = json['years'] ?? 0;
    months = json['months'] ?? 0;
    days = json['days'] ?? 1;
  }

  Map<String, dynamic> toMap() {
    return {
      'years': years,
      'months': months,
      'days': days,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  PeriodicAlert copyWith({int? years, int? months, int? days}) {
    return PeriodicAlert(
      years: years ?? this.years,
      months: months ?? this.months,
      days: days ?? this.days,
    );
  }
}

class FriendModel {
  String? friendId = '';
  String? userId = '';
  String? name = '';
  Timestamp? dob = Timestamp.now();
  Timestamp lastContacted = Timestamp.now();
  int lastContactedDays = 0;
  bool alertOnBirthday = true;
  String profileImage = "";
  PeriodicAlert alert = PeriodicAlert.empty();
  

  FriendModel({
    this.friendId = '',
    this.userId = '',
    this.name = '',
    this.dob,
    required this.lastContacted,
    this.lastContactedDays = 0,
    this.alertOnBirthday = true,
    this.profileImage = '',
    required this.alert
  });

  factory FriendModel.fromMap(Map<String, dynamic> data) {
    return FriendModel(
      friendId: data['friendId'] ?? '',
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      dob: data['dob'] ?? Timestamp.now(),
      lastContacted: data['lastContacted'] ?? Timestamp.now(),
      lastContactedDays: data['lastContactedDays'] ?? 0,
      alertOnBirthday: data['alertOnBirthday'] ?? true,
      profileImage: data['profileImage'] ?? '',
      alert: data['alert'] != null ? PeriodicAlert.fromJson(data['alert']) : PeriodicAlert.empty(),
    );
  }

  FriendModel.fromJson(Map<String, dynamic> json) {
    friendId = json['friendId'] ?? '';
    userId = json['userId'] ?? '';
    name = json['name'] ?? '';
    dob = json['dob'] ?? Timestamp.now();
    lastContacted = json['lastContacted'] ?? Timestamp.now();
    lastContactedDays = json['lastContactedDays'] ?? 0;
    alertOnBirthday = json['alertOnBirthday'] ?? true;
    profileImage = json['profileImage'] ?? '';
    alert = json['alert'] ?? PeriodicAlert.empty();
  }

  Map<String, dynamic> toMap() {
    return {
      'friendId': friendId,
      'userId': userId,
      'name': name,
      'dob': dob,
      'lastContacted': lastContacted,
      'lastContactedDays': lastContactedDays,
      'alertOnBirthday': alertOnBirthday,
      'profileImage': profileImage,
      'alert': alert.toMap()
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

  int calculatePriorityScore() {
    int alertFrequencyInDays = alert.years * 365 + alert.months * 30 + alert.days;
    return lastContactedDays - alertFrequencyInDays;
  }

  calculateSeverity() {
    int priorityScore = calculatePriorityScore();
    if (priorityScore >= 60) {
      return 1;
    } else if (priorityScore <= 30 && priorityScore >= 14) {
      return 2;
    } else {
      return 3;
    }
  }

  getSeverityColor(){
    int severityScore = calculateSeverity();
    return severityScore == 1
      ? GlobalStyles.severeColor
      : severityScore == 2
        ? GlobalStyles.warningColor
        : GlobalStyles.normalColor;
  }
}
