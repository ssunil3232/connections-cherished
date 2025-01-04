import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectionscherished/models/friends_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class FriendService {
  final _firestore = GetIt.I.get<FirebaseFirestore>();
  final _friendsCollection = 'friends';

  Future<void> addFriend(FriendModel friend) async {
    try {
      final friendDocRef = _firestore.collection(_friendsCollection).doc();
      final friendUid = friendDocRef.id;
      friend.friendId = friendUid;

      debugPrint(friend.toString());

      await friendDocRef.set(friend.toMap());
    } catch (e) {
      throw Exception('Error adding friend to friends collection');
    }
  }

  Future<void> updateFriend(String friendId, Map<String, dynamic> friendData) async {
    try {
      await _firestore.collection(_friendsCollection).doc(friendId).update(friendData);
    } catch (e) {
      Exception('Error updating connection: $e');
    }
  }

  Future<void> deleteFriend(String friendId) async {
    try {
      await _firestore.collection(_friendsCollection).doc(friendId).delete();
    } catch (e) {
      throw Exception('Error deleting friend: $e');
    }
  }
}