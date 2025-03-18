import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileImgProvider extends ChangeNotifier {
  Map<String, String> _imageUrls = {};
  String _avatarImgUrl = "";

  Map<String, String> get imageUrls => _imageUrls;
  String get avatarImgUrl => _avatarImgUrl;

  Future<void> setAvatars (String userId) async {
    firebase_storage.ListResult avatars = await firebase_storage
        .FirebaseStorage.instance
        .ref('assets/images/avatars')
        .listAll();

    for (firebase_storage.Reference ref in avatars.items) {
      final String url = ref.fullPath;
      String downloadUrl = await firebase_storage.FirebaseStorage.instance
          .ref(url)
          .getDownloadURL();
      _imageUrls[url] = downloadUrl;
    }

    firebase_storage.ListResult avatarUploads = await firebase_storage
        .FirebaseStorage.instance
        .ref('assets/images/uploads')
        .listAll();

    for (firebase_storage.Reference ref in avatarUploads.items) {
      firebase_storage.FullMetadata metadata = await ref.getMetadata();
      // Check if the userId in metadata matches the provided userId
      if (metadata.customMetadata != null && metadata.customMetadata!['userId'] == userId) {
        final String url = ref.fullPath;
        String downloadUrl = await firebase_storage.FirebaseStorage.instance
            .ref(url)
            .getDownloadURL();
        _imageUrls[url] = downloadUrl;
      }
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