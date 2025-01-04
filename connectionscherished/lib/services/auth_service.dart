import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectionscherished/main.dart';
import 'package:connectionscherished/models/user_model.dart';
import 'package:connectionscherished/routes.dart';
import 'package:connectionscherished/services/routing_service.dart';
import 'package:connectionscherished/user/user_settings.dart';
import 'package:connectionscherished/util/callback.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'dart:developer' as developer;

enum SignInMethod { password, google, phone, apple, none }

class AuthService {
  final FirebaseAuth _authService = FirebaseAuth.instance;
  final _firestore = GetIt.I.get<FirebaseFirestore>();
  final _navService = GetIt.I.get<NavigationService>();
  final _userCollection = 'users';

  Future<bool> checkEmailExists(String email) async {
    try {
      QuerySnapshot emailQuery = await _firestore.collection(_userCollection)
        .where("email", isEqualTo: email)
        .where("isDeleted", isEqualTo: false)
        .get();
      if (emailQuery.docs.isNotEmpty) {
        //Email in use
        developer.log("Email in use");
        return true;
      }
      else{
        developer.log("Email not in use");
        return false;
      }
    } catch (e) {
      throw ('Internal Server Error');
    }
  }

  Future<UserModel?> getUser(String userId) async {
    final userDoc = _firestore.collection(_userCollection).doc(userId);
    final docSnapshot = await userDoc.get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();

      if (data == null) {
        return null;
      }
      return UserModel.fromMap(data);
    }
    return null;
  }

  Future<UserModel?> getLoggedInUser() async {
    User? user = _authService.currentUser;
    if (user != null) {
      return await getUser(user.uid);
    } else {
      throw Exception("User not logged in.");
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      User? currentUser = _authService.currentUser;
      if (currentUser != null) {
        final userDoc = _firestore.collection(_userCollection).doc(currentUser.uid);
        final currentData = await userDoc.get();
        await userDoc.update({
          'userName': user.userName != currentData["userName"] ? user.userName : currentData["userName"],
          'profileImage': user.profileImage != currentData["profileImage"] ? user.profileImage : currentData["profileImage"],
          'email': user.email != currentData["email"] ? user.email : currentData["email"],
          'isDeleted': user.isDeleted != currentData["isDeleted"] ? user.isDeleted : currentData["isDeleted"],
          'enableNotifications': user.enableNotifications != currentData["enableNotifications"] ? user.enableNotifications : currentData["enableNotifications"],
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      else {
        throw Exception("User not logged in.");
      }
    } catch (e) {
      throw Exception("Failed to update user info.");
    }
  }

  checkSplashState() async {
    User? user = _authService.currentUser;
    if (user == null) {
      developer.log("User is not logged in");
      _navService.navigateTo(Routes.authOptions);
    }
    else {
      developer.log("User is logged in: ${user.uid}");
      await checkIfDocExists(userId: user.uid, loginMethod: SignInMethod.none);
    }
  }

  checkIfDocExists({UserCredential ? userCred, required String userId, userProvider, required SignInMethod loginMethod}) async {
      //Fetch User Doc
      final userDoc = _firestore.collection(_userCollection).doc(userId);
      final docSnapshot = await userDoc.get();
      // If the user document does not exist, create it
      if (!docSnapshot.exists && userCred !=null) {
        await userDoc.set({
          'userId': userCred.user!.uid,
          'userName': '',
          'email': loginMethod == SignInMethod.password ? userCred.user!.email : '',
          'profileImage': '',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'isDeleted': false,
          'enableNotifications': true,
        });
        // _navService.navigateTo(Routes.userSettings);
        showDialog(
          context: navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const UserSettingsScreen();
          },
        );
      }
      else{
        //Then navigate to Home screen directly
      _navService.navigateTo(Routes.home);
      }
  }

  Future<void> signInWithPhoneNumber(String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      UserCredential userCred =
          await _authService.signInWithCredential(credential);
      if (userCred.user != null) {
        await checkIfDocExists(userCred: userCred, userId: userCred.user!.uid, userProvider: {"phone": userCred.user!.phoneNumber}, loginMethod: SignInMethod.phone);
      }
    } catch (e) {
      developer.log(e.toString());
    }
  }

  Future<void> signInWithEmail({required String email, required String password}) async {
    try {
      UserCredential userCred = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // If sign-in succeeds, show a snackbar
      developer.log("Login is successful!");
      if (userCred.user != null) {
        await checkIfDocExists(userCred: userCred, userId: userCred.user!.uid, userProvider: {"password": email}, loginMethod: SignInMethod.password);
      }
    } on FirebaseAuthException catch (e) {
      developer.log(e.toString());
      if (e.code == 'user-not-found') {
        throw(Exception('User not found.'));
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password.');
      } else if (e.code == 'invalid-credential') {
        throw Exception('Invalid email or password');
      } else {
        throw Exception('Internal Server Error');
      }
    }
  }

  Future<void> signUpWithEmail({required String email, required String password}) async {
    try {
      // Create user with email and password using Firebase Authentication
      UserCredential userCred = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCred.user != null) {
        await checkIfDocExists(userCred: userCred, userId: userCred.user!.uid, userProvider: {"password": email}, loginMethod: SignInMethod.password);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        developer.log('${e.message}');
        throw Exception('Email already in use');
      } else {
        developer.log('${e.message}');
        throw Exception('Internal Server Error');
      }
    }
  }

  ////////////// Methods for Updates ///////////////
  SignInMethod providerIdToSignInMethod(String method) {
    switch (method) {
      case 'password':
        return SignInMethod.password;
      case 'google.com':
        return SignInMethod.google;
      case 'phone':
        return SignInMethod.phone;
      case 'apple.com':
        return SignInMethod.apple;
      default:
        return SignInMethod.none;
    }
  }

  String signInMethodToProviderId(SignInMethod method) {
    switch (method) {
      case SignInMethod.password:
        return 'password';
      case SignInMethod.google:
        return 'google.com';
      case SignInMethod.phone:
        return 'phone';
      case SignInMethod.apple:
        return 'apple.com';
      default:
        return '';
    }
  }

  List<SignInMethod> getUserSignInMethods() {
    User ? user = _authService.currentUser;
    if (user == null) {
      return [];
    }

    List<String> methods = user.providerData.map((userInfo) => userInfo.providerId).toList();
    List<SignInMethod> signInMethods = methods.map((method) => providerIdToSignInMethod(method)).toList();
    return signInMethods;
  }

  bool accountHasPassword() {
    List<SignInMethod> methods = getUserSignInMethods();
    return methods.contains(SignInMethod.password);
  }

  String getPasswordEmail() {
    User? user = _authService.currentUser;
    if (user == null) {
      return '';
    }
    if (!accountHasPassword()) {
      return '';
    }
    return user.providerData
            .firstWhere((element) => element.providerId == 'password')
            .email ??
        '';
  }

  Future<void> reauthenticateWithEmail({required String email, required String password, SignInCallback? onSignIn}) async {
    try {
      User? user = _authService.currentUser;

      if (user == null) {
        throw Exception('User not logged in.');
      }

      UserCredential userCred = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCred.user == null) {
        throw Exception('User not found.');
      }

      if (userCred.user!.uid != user.uid) {
        throw Exception('User not found.');
      }

      if (onSignIn != null) {
        AuthCredential authCredential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        onSignIn(authCredential);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw(Exception('User not found.'));
      } else if (e.code == 'wrong-password') {
        _navService.showPopup("Wrong password.",
            color: getSnackbarColor(SnackbarType.error));
        throw Exception('Wrong password.');
      } else if (e.code == 'invalid-credential') {
        throw Exception('Invalid email or password');
      } else {
        throw Exception('Internal Server Error');
      }
    }
  }

  Future<void> deleteAccount(credential) async {
    try {
      // First delete the user model
      User? user = _authService.currentUser;
      if (user == null) {
        return;
      }

      await user.reauthenticateWithCredential(credential);

      await _firestore.collection(_userCollection).doc(user.uid).update({
        'isDeleted': true
      });

      await user.delete();
      await _authService.signOut();
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
        Routes.splash,
        (route) => false,
      );
    } catch (e) {
      Exception(e);
    }
  }

}
