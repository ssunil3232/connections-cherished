import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileImgProvider extends ChangeNotifier {
  final SupabaseClient _authService = Supabase.instance.client;
  Map<String, String> _imageUrls = {};
  String _avatarImgUrl = "";

  Map<String, String> get imageUrls => _imageUrls;
  String get avatarImgUrl => _avatarImgUrl;

  Future<void> setAvatars (String userId) async {
    final avatars = await _authService.storage.from('avatars').list();
    for (final file in avatars) {
      final String url = file.name;
      final String downloadUrl = _authService.storage.from('avatars').getPublicUrl(file.name);
      _imageUrls[url] = downloadUrl;
    }

    final response = await _authService.from('upload_image').select('image_url').eq('user_id', userId);
    final List<String> avatarUploads = (response as List).map((e) => e['image_url'] as String).toList();
    // .then((data) {
    //   if (data.isEmpty) {
    //     return data.map((e) => e['imageUrl'] as String).toList();
    //   }
    //   return [];
    // });
    for (final file in avatarUploads) {
      final String url = file;
      final String downloadUrl = _authService.storage.from('uploads').getPublicUrl(file);
      _imageUrls[url] = downloadUrl;
    }
    notifyListeners();
  }

  Future<void> updateAvatars(String url, String downloadUrl) async {
    _imageUrls[url] = downloadUrl;
    notifyListeners();
  }

  Future<void> setUserAvatar (String img) async {
    _avatarImgUrl = _imageUrls[img]!;
    notifyListeners();
  }

  Future<void> resetProvider() async {
    _imageUrls = {};
    _avatarImgUrl = "";
    notifyListeners();
  }
}