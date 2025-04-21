import 'package:connectionscherished/main.dart';
import 'package:connectionscherished/models/user_model.dart';
import 'package:connectionscherished/routes.dart';
import 'package:connectionscherished/services/providers/profile_img_provider.dart';
import 'package:connectionscherished/services/routing_service.dart';
import 'package:connectionscherished/services/util_service.dart';
import 'package:connectionscherished/util/callback.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer' as developer;
import 'package:supabase_flutter/supabase_flutter.dart';

enum SignInMethod { email, google, phone, apple, none }

class AuthService {
  final SupabaseClient _authService = Supabase.instance.client;
  final _navService = GetIt.I.get<NavigationService>();
  final _utilService = GetIt.I.get<UtilService>();
  final ProfileImgProvider _imgProvider = GetIt.instance<ProfileImgProvider>();
  final _userCollection = 'users';
  
  checkSplashState() async {
    await _imgProvider.resetProvider();
    Session? session = _authService.auth.currentSession;
    User? user = getSupabaseUser();
    if (user == null || session == null) {
      developer.log("User is not logged in");
      _navService.navigateTo(Routes.authOptions);
    }
    else {
      developer.log("User is logged in: ${user.id}");
      await checkIfUserExists(userId: user.id, userCred: user, loginMethod: SignInMethod.none);
    }
  }
  
  Future<bool> checkEmailExists(String email) async {
    await _imgProvider.resetProvider();
    final res = await _authService.functions.invoke('check-email', body: {'email': email});
    if(res.status == 200) {
      if(res.data != null) {
        debugPrint('Response data: ${res.data}');
        return res.data['exists']; 
      } else {
        throw Exception('No data returned from the function');
      }
    } else {
      throw Exception('Failed to verify email existence');
    }
  }

  checkIfUserExists({required String userId, required User userCred, required SignInMethod loginMethod}) async {
    await _imgProvider.setAvatars(userId);
    //Fetch User Doc
    try {
      final data = await _authService.from(_userCollection).select('*').eq('user_id', userId).single().maybeSingle();
      if (data == null) {
        // No record exists for this user.
        debugPrint('No record found for user with ID: $userId');
        String profileImg = await _utilService.getUserAvatar();
        UserModel user = UserModel(
          userId: userId,
          email: (loginMethod == SignInMethod.email || loginMethod == SignInMethod.google) ? userCred.email ?? '' : '',
          profileImage: profileImg
        );
         await _authService.from(_userCollection).insert(user.insertMap());
        _navService.navigateTo(Routes.createAccount);
      } else {
        // The record exists. Process or display it as needed.
        debugPrint('Record found: $data');
        UserModel user = UserModel.fromMap(data);
        if(user.userName.isNotEmpty){
          _navService.navigateTo(Routes.dashboard);
        }
        else{
          _navService.navigateTo(Routes.createAccount);
        }
      }
    } catch (error) {
        _navService.showPopup("Error retrieving account info. Please try again.",
          color: getSnackbarColor(SnackbarType.alert));
        _navService.navigateTo(Routes.authOptions);
    }
  }

  Future<void> signInWithGoogle() async {
    await _imgProvider.resetProvider();
    const webClientId = '815352262580-4kbfo69g1bk2fspkvcmugvkd0grc3car.apps.googleusercontent.com';
    const iosClientId = '815352262580-ktdvco6j619lqu16h8vjjien7pafij5p.apps.googleusercontent.com';
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        throw Exception('Google Sign-In was canceled.');
      }
      else {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final accessToken = googleAuth.accessToken;
        final idToken = googleAuth.idToken;
        if (accessToken == null) {
          throw 'No Access Token found.';
        }
        if (idToken == null) {
          throw 'No ID Token found.';
        }
        debugPrint('Access Token: $accessToken'); 
        AuthResponse userCred = await _authService.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
          accessToken: accessToken,
        );
        if (userCred.user != null) {
          await checkIfUserExists(userId: userCred.user!.id, userCred: userCred.user!, loginMethod:  SignInMethod.google);
        }
      }
    } catch (e) {
      developer.log('Google Sign-In failed: $e');
      throw Exception('Google Sign-In failed.');
    }
  }

  ////////////// Methods for Updates ///////////////
  SignInMethod providerIdToSignInMethod(String method) {
    debugPrint('Provider ID: $method');
    switch (method) {
      case 'email':
        return SignInMethod.email;
      case 'google.com' || 'google':
        return SignInMethod.google;
      case 'phone':
        return SignInMethod.phone;
      case 'apple.com' || 'apple':
        return SignInMethod.apple;
      default:
        return SignInMethod.none;
    }
  }

  List<SignInMethod> getUserSignInMethods() {
    User ? user = getSupabaseUser();
    if (user == null) {
      _navService.showPopup("Error retrieving account info. Please login again.",
          color: getSnackbarColor(SnackbarType.alert));
      return [];
    }
    List<dynamic> methods = user.appMetadata['providers'];
    List<SignInMethod> signInMethods = methods.map((method) => providerIdToSignInMethod(method)).toList();
    return signInMethods;
  }

  bool accountIsEmailLogin() {
    List<SignInMethod> methods = getUserSignInMethods();
    return methods.contains(SignInMethod.email);
  }

  String getAccountEmail() {
    User ? user = getSupabaseUser();
    if (user == null) {
      return '';
    }
    if (!accountIsEmailLogin()) {
      return '';
    }
    return user.email ?? '';
  }

  bool accountIsGoogleLogin() {
    List<SignInMethod> methods = getUserSignInMethods();
    return methods.contains(SignInMethod.google);
  }

  String getGoogleEmail() {
    User ? user = getSupabaseUser();
    if (user == null) {
      return '';
    }
    if (!accountIsGoogleLogin()) {
      return '';
    }
    return user.email ?? '';
  }

  Future<void> reauthenticateAccount({required String email, required String otpResult, SignInCallback? onReauth, required OtpType otpType}) async {
    try {
      User? user = getSupabaseUser();
      if (user == null) {
        throw AuthException('No user is signed in.');
      }
      // final AuthResponse res = await _authService.auth.verifyOTP(
      //   type: otpType,
      //   token: otpResult,
      //   email: email,
      // );
      // if (onReauth != null) {
      //   if(res.session !=null && res.user != null) {
      //   onReauth(res.user);
      //   }
      //   else {
      //     throw Exception('Error reauthenticating user.');
      //   }
      // }
      // else{
      //   throw Exception('Error reauthenticating user.');
      // }
      if (onReauth != null) {
        onReauth(user);
      }
      else{
        throw Exception('Error reauthenticating user.');
      }
    } catch (e) {
      if (e is AuthException) {
        _navService.showPopup(e.message,
            color: getSnackbarColor(SnackbarType.error));
      } else {
        _navService.showPopup("Internal Server Error",
            color: getSnackbarColor(SnackbarType.error));
      }
    }
    // on firebase.FirebaseAuthException catch (e) {
    //   if (e.code == 'user-not-found') {
    //     throw(Exception('User not found.'));
    //   } else if (e.code == 'wrong-password') {
    //     _navService.showPopup("Wrong password.",
    //         color: getSnackbarColor(SnackbarType.error));
    //     throw Exception('Wrong password.');
    //   } else if (e.code == 'invalid-credential') {
    //     throw Exception('Invalid email or password');
    //   } else {
    //     throw Exception('Internal Server Error');
    //   }
    // }
  }

  // Future<void> reauthenticateWithGoogle({SignInCallback? onSignIn, User? user}) async {
  //   try {
  //     if (user == null) {
  //       throw Exception("User not logged in.");
  //     }

  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //     if (googleUser == null) {
  //       throw Exception("Google Sign In canceled.");
  //     }
  //     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  //     final authCredential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     await user.reauthenticateWithCredential(authCredential);

  //     if (onSignIn != null) {
  //       onSignIn(authCredential);
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-mismatch') {
  //       _navService.showPopup("User mismatch. Please reauthenticate with the provided email.",
  //         color: getSnackbarColor(SnackbarType.error));
  //     } else if (e.code == "user-not-found"){
  //       _navService.showPopup("User not found. Please reauthenticate with the provided email.",
  //         color: getSnackbarColor(SnackbarType.error));
  //     }
  //     else{
  //       _navService.showPopup("Error while logging in using Google",
  //         color: getSnackbarColor(SnackbarType.error));
  //     }
  //     developer.log('FirebaseAuthException during Google reauthentication: $e');
  //   } catch (e) {
  //     developer.log('Error during Google reauthentication: $e');
  //     _navService.showPopup("Error while logging in using Google",
  //         color: getSnackbarColor(SnackbarType.error));
  //   }
  // }

  User? getSupabaseUser() {
    return _authService.auth.currentUser;
  }

  ////////////////////////////////////////////////
  Future<void> deleteAccount(User credentials) async {
    final res = await _authService.functions.invoke('delete-user', body: {'user_id': credentials.id});
    if(res.status == 200) {
      await _authService.auth.signOut();
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
        Routes.authOptions,
        (route) => false,
      );
    } else {
      throw Exception('Failed to delete user');
    }

      // await _firestore.collection(_userCollection).doc(user.uid).update({
      //   'isDeleted': true
      // });
      // final historyData = await _firestore.collection("contact_history").where('userId', isEqualTo: user.uid).get();
      // if (historyData.docs.isNotEmpty) {
      //   final batch = _firestore.batch();
      //   for (final doc in historyData.docs) {
      //     batch.delete(doc.reference);
      //   }
      //   await batch.commit();
      // }
      // await user.delete();
      // await _firebaseAuthService.signOut();
  }

}
