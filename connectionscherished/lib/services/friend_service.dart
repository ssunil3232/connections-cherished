import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectionscherished/models/friends_model.dart';
import 'package:connectionscherished/models/journal_model.dart';
import 'package:connectionscherished/services/util_service.dart';
import 'package:connectionscherished/widgets/profile/profile_img_name_dialog.dart';
import 'package:get_it/get_it.dart';

class FriendService {
  final _firestore = GetIt.I.get<FirebaseFirestore>();
  final _utilService = GetIt.I.get<UtilService>();
  final _friendsCollection = 'friends';

  Future<void> addFriend({required FriendModel friend, required AvatarImgSelection avatar}) async {
    try {
      final friendDocRef = _firestore.collection(_friendsCollection).doc();
      final friendUid = friendDocRef.id;
      friend.friendId = friendUid;
      await _utilService.uploadImage(avatar, friendUid);
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
      await _utilService.deleteAssociatedImg(friendId, 'associatedId');
    } catch (e) {
      throw Exception('Error deleting friend: $e');
    }
  }

  //////////////////Journal Entries//////////////////

  Future<List<JournalModel>> getFriendsJournals(String friendId) async {
    try {
      final journalsCollection = await _firestore.collection("journals");
      final journals = await journalsCollection.where('friendId', isEqualTo: friendId).get();
      if (journals.docs.isEmpty) {
        return [];
      }
      return journals.docs.map((doc) => JournalModel.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception('Error fetching journals: $e');
    }
  }

  Future<void> addJournalEntry(JournalModel journal) async {
    try {
      final journalDocRef = _firestore.collection("journals").doc();
      final journalUid = journalDocRef.id;
      journal.journalId = journalUid;
      await journalDocRef.set(journal.toMap());
    } catch (e) {
      throw Exception('Error adding journal entry: $e');
    }
  }

  Future<void> updateJournalEntry(JournalModel journal) async {
    try {
      await _firestore.collection("journals").doc(journal.journalId).update(journal.toMap());
    } catch (e) {
      Exception('Error updating journal entry: $e');
    }
  }

  Future<void> deleteJournalEntry(JournalModel journal) async {
    try {
      await _firestore.collection("journals").doc(journal.journalId).delete();
    } catch (e) {
      throw Exception('Error deleting journal entry: $e');
    }
  }
}