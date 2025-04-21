import 'dart:convert';
import 'package:azlistview/azlistview.dart';

class TimezoneModel extends ISuspensionBean {
  String location = '';
  String label = '';
  String offset_hours = '';
  String tag;

  TimezoneModel({
    required this.location, required this.label, this.offset_hours = '', this.tag = '',
  });

  TimezoneModel.empty()
      : location = '',
        label = '',
        offset_hours = '',
        tag = '';

  TimezoneModel.fromJson(Map<String, dynamic> data)
      : location = data['location'] ?? 'Unknown',
        label = data['label'] ?? 'Unknown',
        offset_hours = data['offset_hours'] ?? 'UTC +00:00',
        tag = '';

  @override
  String toString() {
    return 'TimezoneModel(\n'
      '   location: $location,\n'
      '   label: $label,\n'
      '   offset_hours: $offset_hours,\n'
      '   tag: $tag,\n'
      ')';
  }

  factory TimezoneModel.fromMap(Map<String, dynamic> data) {
    return TimezoneModel(
      location: data['location'] ?? 'Unknown',
      label: data['label'] ?? 'Unknown',
      offset_hours: data['offset_hours'] ?? 'UTC +00:00',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'label': label,
      'offset_hours': offset_hours,
    };
  }

  String toJson() => jsonEncode(toMap());

  TimezoneModel copyWith({String? location, String? label, String? offset_hours}) {
    return TimezoneModel(
      location: location ?? this.location,
      label: label ?? this.label,
      offset_hours: offset_hours ?? this.offset_hours,
    );
  }

  String get cityName {
    final parts = location.split('/');
    return parts.isNotEmpty ? parts.last : location;
  }

  @override
  String getSuspensionTag() => tag;
}