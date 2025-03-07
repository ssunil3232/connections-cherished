import 'dart:convert';

class TimezoneModel {
  String location = '';
  String label = '';
  String offset_hours = '';

  TimezoneModel({
    required this.location, required this.label, this.offset_hours = ''
  });

  TimezoneModel.empty();

  TimezoneModel.fromJson(Map<String, dynamic> data) {
    location = data['location'] ?? 'Unknown';
    label = data['label'] ?? 'Unknown, (UTC+00:00)';
    offset_hours = data['offset_hours'] ?? '+00:00';
  }

  factory TimezoneModel.fromMap(Map<String, dynamic> data) {
    return TimezoneModel(
      location: data['location'] ?? 'Unknown',
      label: data['label'] ?? 'Unknown, (UTC+00:00)',
      offset_hours: data['offset_hours'] ?? '+00:00'
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'label': label,
      'offset_hours': offset_hours,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  TimezoneModel copyWith({String? location, String? label, String ? offset_hours}) {
    return TimezoneModel(
      location: location ?? this.location,
      label: label ?? this.label,
      offset_hours: offset_hours ?? this.offset_hours,
    );
  }
}