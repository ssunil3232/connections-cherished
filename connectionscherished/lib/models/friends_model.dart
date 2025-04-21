import 'dart:convert';
import 'package:connectionscherished/styles/styles.dart';

class PeriodicAlert {
  int months = 0;
  int weeks = 1;
  int days = 0;

  PeriodicAlert({
    required this.weeks, required this.months, required this.days
  });

  PeriodicAlert.empty();

  PeriodicAlert.fromJson(Map<String, dynamic> json) {
    weeks = json['weeks'] ?? 1;
    months = json['months'] ?? 0;
    days = json['days'] ?? 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'weeks': weeks,
      'months': months,
      'days': days,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  PeriodicAlert copyWith({int? weeks, int? months, int? days}) {
    return PeriodicAlert(
      weeks: weeks ?? this.weeks,
      months: months ?? this.months,
      days: days ?? this.days,
    );
  }
}

class FriendModel {
  String? friendId = '';
  String? userId = '';
  String? name = '';
  DateTime dob = DateTime(2024, 1, 1);
  DateTime lastContacted = DateTime.now();
  int lastContactedDays = 0;
  bool alertOnBirthday = true;
  String profileImage = "";
  PeriodicAlert alert = PeriodicAlert.empty();
  String timezone = '';
  DateTime ? createdAt = DateTime.now();
  DateTime ? updatedAt = DateTime.now();

  FriendModel({
    this.friendId = '',
    this.userId = '',
    this.name = '',
    required this.dob,
    required this.lastContacted,
    this.lastContactedDays = 0,
    this.alertOnBirthday = true,
    this.profileImage = '',
    required this.alert,
    this.timezone = '',
    this.createdAt,
    this.updatedAt,
  });

  factory FriendModel.fromMap(Map<String, dynamic> data) {
    return FriendModel(
      friendId: data['friend_id'] ?? '',
      userId: data['user_id'] ?? '',
      name: data['name'] ?? '',
      dob: data['dob'] !=null ? DateTime.parse(data['dob']) : DateTime(2024, 1, 1),
      lastContacted: data['last_contacted'] !=null ? DateTime.parse(data['last_contacted']) : DateTime.now(),
      lastContactedDays: data['last_contacted_days'] ?? 0,
      alertOnBirthday: data['alert_on_birthday'] ?? true,
      profileImage: data['profile_image'] ?? '',
      alert: data['alert'] != null ? PeriodicAlert.fromJson(data['alert']) : PeriodicAlert.empty(),
      timezone: data['timezone'] ?? '',
      createdAt: data['created_at'] != null ? DateTime.parse(data['created_at']) : null,
      updatedAt: data['updated_at'] != null ? DateTime.parse(data['updated_at']) : null,
    );
  }

  // FriendModel.fromJson(Map<String, dynamic> json) {
  //   friendId = json['friendId'] ?? '';
  //   userId = json['userId'] ?? '';
  //   name = json['name'] ?? '';
  //   dob = json['dob'] ?? Timestamp.now();
  //   lastContacted = json['lastContacted'] ?? Timestamp.now();
  //   lastContactedDays = json['lastContactedDays'] ?? 0;
  //   alertOnBirthday = json['alertOnBirthday'] ?? true;
  //   profileImage = json['profileImage'] ?? '';
  //   alert = json['alert'] ?? PeriodicAlert.empty();
  //   timezone = json['timezone'] ?? '';
  // }

  Map<String, dynamic> toMap() {
    return {
      'friend_id': friendId,
      'user_id': userId,
      'name': name,
      'dob': dob.toIso8601String(),
      'last_contacted': lastContacted.toIso8601String(),
      'last_contacted_days': lastContactedDays,
      'alert_on_birthday': alertOnBirthday,
      'profile_image': profileImage,
      'alert': alert.toMap(),
      'timezone': timezone,
      'created_at': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  Map<String, dynamic> insertMap() {
    return {
      'user_id': userId,
      'name': name,
      'dob': dob.toIso8601String(),
      'last_contacted': lastContacted.toIso8601String(),
      'last_contacted_days': lastContactedDays,
      'alert_on_birthday': alertOnBirthday,
      'profile_image': profileImage,
      'alert': alert.toMap(),
      'timezone': timezone,
      'created_at': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
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
    int alertFrequencyInDays = alert.weeks * 7 + alert.months * 30 + alert.days;
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
      ? GlobalStyles.criticalColor
      : severityScore == 2
        ? GlobalStyles.warningColor
        : GlobalStyles.neutralColor;
  }
}
