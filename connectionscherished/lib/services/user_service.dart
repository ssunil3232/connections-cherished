import 'package:connectionscherished/models/friends_model.dart';
import 'package:connectionscherished/models/user_model.dart';
import 'package:connectionscherished/routes.dart';
import 'package:connectionscherished/services/friend_service.dart';
import 'package:connectionscherished/services/routing_service.dart';
import 'package:connectionscherished/services/util_service.dart';
import 'package:connectionscherished/widgets/profile/profile_img_name_dialog.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final SupabaseClient _authService = Supabase.instance.client;
  final _navService = GetIt.I.get<NavigationService>();
  final FriendService _friendService = GetIt.I<FriendService>();
  final _utilService = GetIt.I.get<UtilService>();
  final _userCollection = 'users';
  final _friendsCollection = 'friends';

  User? getSupabaseUser() {
    return _authService.auth.currentUser;
  }

  Future<UserModel?> getUser(String userId) async {
    final data = await _authService.from(_userCollection).select('*').eq('user_id', userId).single().maybeSingle();
    if (data != null) {
      return UserModel.fromMap(data);
    }
    return null;
  }

  Future<UserModel?> getLoggedInUser() async {
    User? user = getSupabaseUser();
    if (user != null) {
      return await getUser(user.id);
    } else {
      throw Exception("User not logged in.");
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      User ? currentUser = getSupabaseUser();
      if (currentUser != null) {
        if(user.profileImage.isEmpty){
          user.profileImage = await _utilService.getUserAvatar();
        }
        user.updatedAt = DateTime.now();
        await _authService.from(_userCollection).update(user.toMap())
        .eq('user_id', currentUser.id);
      }
      else {
        _navService.navigateTo(Routes.authOptions);
        _navService.showPopup("User not logged in.",
            color: getSnackbarColor(SnackbarType.error));
        throw Exception("User not logged in.");

      }
    } catch (e) {
      _navService.showPopup("Failed to update user info.",
            color: getSnackbarColor(SnackbarType.error));
      throw Exception("Failed to update user info.");
    }
  }

  Future<List<FriendModel>> getFriends() async {
    try {
      User ? user = getSupabaseUser();
      if (user != null) {
        final friends = await _authService.from(_friendsCollection).select('*').eq('user_id', user.id);
        if (friends.isEmpty) {
          return [];
        }
        return friends
            .map((doc) => FriendModel.fromMap(doc))
            .toList();
      } else {
        _navService.showPopup("User not logged in.",
            color: getSnackbarColor(SnackbarType.error));
        throw Exception("User not logged in.");
      }
    } catch (e) {
      _navService.showPopup("Failed to retrieve friends.",
          color: getSnackbarColor(SnackbarType.error));
      throw Exception("Failed to retrieve friends.");
    }
  }

  Future<void> addFriendToUser(FriendModel friend, AvatarImgSelection avatar) async {
    try {
      User ? user = getSupabaseUser();
      if (user != null) {
        friend.userId = user.id;
        await _friendService.addFriend(friend: friend, avatar: avatar);
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
