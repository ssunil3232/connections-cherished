import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectionscherished/models/friends_model.dart';
import 'package:connectionscherished/models/user_model.dart';
import 'package:connectionscherished/services/friend_service.dart';
import 'package:connectionscherished/services/routing_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

class UserService {
  final FirebaseAuth _authService = FirebaseAuth.instance;
  final _firestore = GetIt.I.get<FirebaseFirestore>();
  final _navService = GetIt.I.get<NavigationService>();
  final FriendService _friendService = GetIt.I<FriendService>();
  final _userCollection = 'users';

  Future<void> addUserInfo(UserModel updatedUser) async {
    try {
      User? user = _authService.currentUser;
      if (user != null) {
        final userDoc = _firestore.collection(_userCollection).doc(user.uid);
        final currentData = await userDoc.get();
        // if(updatedUser.profileImage.isEmpty){
        //   updatedUser.profileImage = await getUserAvatar();
        // }
        await userDoc.update({
          'userName': updatedUser.userName.isNotEmpty ? updatedUser.userName : currentData["userName"],
          'updatedAt': FieldValue.serverTimestamp(),
          // 'profileImage': updatedUser.profileImage,
        });
      }
      else {
        _navService.showPopup("User not logged in.",
            color: getSnackbarColor(SnackbarType.error));
        throw Exception("User not logged in.");
        //Should we also redirect to login?
      }
    } catch (e) {
      _navService.showPopup("Failed to update user.",
          color: getSnackbarColor(SnackbarType.error));
      throw Exception("Failed to update user info.");
    }
  }

  Future<List<FriendModel>> getFriends() async {
    try {
      User? user = _authService.currentUser;
      if (user != null) {
        final friendsCollection = _firestore.collection('friends');
        final friends = await friendsCollection
            .where('userId', isEqualTo: user.uid)
            .get();
        if (friends.docs.isEmpty) {
          return [];
        }
        return friends.docs
            .map((doc) => FriendModel.fromMap(doc.data()))
            .toList();
      } else {
        _navService.showPopup("User not logged in.",
            color: getSnackbarColor(SnackbarType.error));
        throw Exception("User not logged in.");
      }
    } catch (e) {
      _navService.showPopup("Failed to get friends.",
          color: getSnackbarColor(SnackbarType.error));
      throw Exception("Failed to get friends.");
    }
  }

  Future<void> addFriendToUser(FriendModel friend) async {
    try {
      User? user = _authService.currentUser;
      if (user != null) {

        friend.userId = user.uid;
        await _friendService.addFriend(friend);
        
        _navService.showPopup("Connection added successfully!",
            color: getSnackbarColor(SnackbarType.success));
      } else {
        _navService.showPopup("User not logged in.",
            color: getSnackbarColor(SnackbarType.error));
      }
    } catch (e) {
      _navService.showPopup("Failed to add connection.",
          color: getSnackbarColor(SnackbarType.error));
      throw Exception("Failed to add connection.");
    }
  }
}
