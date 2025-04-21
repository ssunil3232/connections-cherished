import 'dart:math';
import 'package:connectionscherished/services/providers/profile_img_provider.dart';
import 'package:connectionscherished/widgets/profile/profile_img_name_dialog.dart';
import 'package:connectionscherished/models/timezone_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/standalone.dart' as tz;

class UtilService {
  final SupabaseClient _authService = Supabase.instance.client;
  final ProfileImgProvider _imgProvider = GetIt.instance<ProfileImgProvider>();
  final timezoneCollection = "timezones";

  formatOffset(int ? value){
    if (value == null) {
      return "UTC +00:00";
    }
    var offsetSeconds = value;
    var hours = offsetSeconds ~/ 3600000;
    var minutes = ((offsetSeconds.abs() % 3600000) ~/ 60);
    var offsetFormatted = 'UTC ${offsetSeconds >= 0 ? '+' : '-'}${hours.abs().toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    return offsetFormatted; 
  }

  // to get list of timezones
  Future<List<TimezoneModel>> fetchTimezones() async {
    List<TimezoneModel> timezones = [];
    tz.timeZoneDatabase.locations.forEach((key, value) {
      TimezoneModel timezone = TimezoneModel(
        location: key,
        label: value.name.replaceAll('_', ' '),
        offset_hours: '${formatOffset(value.currentTimeZone.offset)}',
      );
      timezones.add(timezone);
    });
    return timezones;
  }

  // to get timezone by location
  Future<TimezoneModel> getTimezone(String zoneName) async {
    List<TimezoneModel> timezones = await fetchTimezones();
    TimezoneModel? selectedTimezone = timezones.firstWhere(
      (timezone) => timezone.location == zoneName,
      orElse: () => TimezoneModel(location: "Unknown", label: "Unknown", offset_hours: "UTC +00:00"),
    );
    return selectedTimezone;
  }

  // to get local timezone
  Future<TimezoneModel> getLocalTimezone() async {
    var currentZone = await FlutterTimezone.getLocalTimezone();
    if (currentZone.isNotEmpty) {
      TimezoneModel localTimezone = await getTimezone(currentZone);
      return localTimezone;
    }
    return TimezoneModel(location: "Unknown", label: "Unknown", offset_hours: "UTC +00:00");
  }

  Future<String> getUserAvatar() async {
    final List<String> imageUrls = [];
    final avatars = await _authService.storage.from('avatars').list();
    for (final file in avatars) {
      final String url = file.name;//_authService.storage.from('avatars').getPublicUrl(file.name);
      imageUrls.add(url);
    }
    final random = Random();
    final img = imageUrls.removeAt(random.nextInt(imageUrls.length));
    return img;
  }

  Future<void> uploadImage(AvatarImgSelection avatar, String id) async {
    if (avatar.imgFile == null) return;
    //String fileName = path.basename(avatar.imgFile!.path);
    String fileName = path.basename(avatar.img);
    String userId = _authService.auth.currentUser?.id ?? '';
    try {
      // Check if the id has an image associated with it
      final data = await _authService.from('upload_image').select('*').eq('associated_id', id).maybeSingle();
      if (data != null) {
        // If the id has an image associated, delete it from storage
        await _authService.storage.from('uploads').remove(['${data['image_url']}']);
        // Then upload the new image to Storage
        await _authService.storage.from('uploads').upload(fileName, avatar.imgFile!);
        // Update the record in the database
        await _authService.from('upload_image').update({
          ...data,
          'image_url': fileName,
        }).eq('associated_id', id);
      }
      else {
        await _authService.storage.from('uploads').upload(fileName, avatar.imgFile!);
        await _authService.from('upload_image').insert({
          'associated_id': id,
          'image_url': fileName,
          'user_id': userId,
        });
      }
      // Retrieve the download URL after successful upload
      String downloadUrl = _authService.storage.from('uploads').getPublicUrl(fileName);
      _imgProvider.updateAvatars(avatar.img, downloadUrl);

    } catch (e) {
      debugPrint('Error uploading image: $e');
    }
  }

  Future<Map<String,dynamic>> getAnalytics(String userId) async {
    try {
      // Make the HTTP GET request
      final response = await _authService.functions.invoke('fetch-analytics', body: {'user_id': userId});
      // Check if the response is successful
      if (response.status == 200) {
        // Decode the JSON response
        final data = response.data;
        if (data['analytics'] is Map<String,dynamic>) {
          final contactHistory = Map<String,dynamic>.from(data['analytics']);
          return contactHistory;
        } else {
          debugPrint('Invalid response format');
          return {};
        }
      } else {
        throw Exception('Failed to fetch friends: ${response.status}');
      }
    } catch (e) {
      // Handle errors
      debugPrint('Error fetching friends: $e');
      return {};
    }
  }
}