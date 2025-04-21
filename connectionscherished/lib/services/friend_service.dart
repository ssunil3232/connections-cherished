import 'package:connectionscherished/models/contact_history_model.dart';
import 'package:connectionscherished/models/friends_model.dart';
import 'package:connectionscherished/models/journal_model.dart';
import 'package:connectionscherished/services/util_service.dart';
import 'package:connectionscherished/user/connection_detail.dart';
import 'package:connectionscherished/widgets/profile/profile_img_name_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FriendService {
  final SupabaseClient _authService = Supabase.instance.client;
  final _utilService = GetIt.I.get<UtilService>();
  final _friendsCollection = 'friends';
  final _contactHistoryCollection = 'contact_history';
  final _journalsCollection = 'journals';

  Future<void> addFriend({required FriendModel friend, required AvatarImgSelection avatar}) async {
    try {
      final insertResponse = await _authService.from(_friendsCollection).insert(friend.insertMap()).select().single();
      String friendUid = insertResponse['friend_id'];
      await _utilService.uploadImage(avatar, friendUid);
      await addContactHistory(
        history: ContactHistoryModel(
          friendId: friendUid,
          userId: friend.userId,
          lastContacted: friend.lastContacted
        ),
        type: ConnectionType.add,
      );
    } catch (e) {
      throw Exception('Error adding friend to friends collection');
    }
  }

  Future<void> updateFriend(String friendId, FriendModel friendData) async {
    try {
      await addContactHistory(
        history: ContactHistoryModel(
          friendId: friendId, 
          userId: friendData.userId,
          lastContacted: friendData.lastContacted
        ),
        type: ConnectionType.edit,
      );
      await _authService.from(_friendsCollection).update(friendData.toMap())
        .eq('friend_id', friendId);
    } catch (e) {
      Exception('Error updating connection: $e');
    }
  }

  Future<void> deleteFriend(String friendId) async {
    try {
      await _authService.from(_friendsCollection).delete()
        .eq('friend_id', friendId);
    } catch (e) {
      throw Exception('Error deleting friend: $e');
    }
  }

  //////////////////Journal Entries//////////////////
  Future<List<JournalModel>> getFriendsJournals(String friendId) async {
    try {
      final journals = await _authService.from(_journalsCollection)
          .select('*')
          .eq('friend_id', friendId);
      if (journals.isEmpty) {
        return [];
      }
      return journals.map((doc) => JournalModel.fromMap(doc)).toList();
    } catch (e) {
      throw Exception('Error fetching journals: $e');
    }
  }

  Future<void> addJournalEntry(JournalModel journal) async {
    try {
      await _authService.from(_journalsCollection).insert(journal.insertMap());
    } catch (e) {
      throw Exception('Error adding journal entry: $e');
    }
  }

  Future<void> updateJournalEntry(JournalModel journal) async {
    try {
      await _authService.from(_journalsCollection).update(journal.toMap()).eq('journal_id', journal.journalId!);
    } catch (e) {
      Exception('Error updating journal entry: $e');
    }
  }

  Future<void> deleteJournalEntry(JournalModel journal) async {
    try {
      await _authService.from(_journalsCollection).delete()
        .eq('journal_id', journal.journalId!);
    } catch (e) {
      throw Exception('Error deleting journal entry: $e');
    }
  }

  Future<void> addContactHistory({required ContactHistoryModel history, required ConnectionType type}) async {
    if(type == ConnectionType.add) {
      try {
        await _authService.from(_contactHistoryCollection).insert(history.insertMap());
      } catch (e) {
        throw Exception('Error adding to history collection');
      }
    }
    else{
      try {
        // Make the HTTP POST request
        final res = await _authService.functions.invoke('manage-contact-history', body: {'friend_id': history.friendId, 'contact_date': history.lastContacted.toIso8601String()});
        if(res.status == 200) {
          try {
            await _authService.from(_contactHistoryCollection).insert(history.insertMap());
          } catch (e) {
            debugPrint('Error 1');
            throw Exception('Error updating contact history');
          }
        } else {
          throw Exception('Failed to update contact history: ${res.status}');
        }
      } catch (e) {
        // Handle errors
        throw Exception('Error updating contact history: $e');
      }
    }
  }
}