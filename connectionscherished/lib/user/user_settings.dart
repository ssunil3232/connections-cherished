import 'package:connectionscherished/models/user_model.dart';
import 'package:connectionscherished/routes.dart';
import 'package:connectionscherished/services/routing_service.dart';
import 'package:connectionscherished/services/user_service.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/custom_button_widget.dart';
import 'package:connectionscherished/widgets/form-fields/input_field_widget.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:get_it/get_it.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  final _userNameController = TextEditingController();
  final _navService = GetIt.I.get<NavigationService>();
  final _userService = GetIt.I.get<UserService>();
  final RegExp nameRegex = RegExp(r"^[a-zA-Z0-9_\xC0-\uFFFF]+([ \-']{0,1}[a-zA-Z0-9_\xC0-\uFFFF]+){0,2}[.]{0,1}$");
  bool _isSaving = false;
  bool _allValid = false;
  bool _showNameError = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _userNameController.addListener(_updateButtonState);
  }

  // validate user name
  bool _isNameValid() {
    final name = _userNameController.text.trim();
    if(name.isEmpty) {
      _showNameError = false;
      return false;
    }
    _showNameError = !nameRegex.hasMatch(name);
    return !_showNameError;
  }

  // update button state
  void _updateButtonState() {
    setState(() {
      _allValid = _isNameValid();
    });
  }

  // save user info and navigate to dashboard
  void _saveUserInfoAndNavigate() async {
    // save user info
    UserModel user = UserModel(
      userName: _userNameController.text
    );
    setState(() {
      _isSaving = true;
      FocusScope.of(context).unfocus();
    });
    try {
      await _userService.addUserInfo(user);
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        _isSaving = false;
      });
      // Navigate to home screen
      Navigator.of(context).pop();
      _navService.navigateTo(Routes.home);
      //To show pop up message
    } catch (e) {
      developer.log("failed");
    }
  }
  
  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('Let’s set up your profile ☺️', style: GlobalStyles.textStyles.heading2,),
        content: Form(
          key: _formKey,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // User name
                Padding(
                  padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing16),
                  child: InputFieldWidget(
                    controller: _userNameController,
                    keyboardType: TextInputType.name,
                    labelText: 'Your name',
                    placeholderText: 'Jane Doe',
                    errorState: _showNameError,
                    errorText: "❌ Invalid name format. \nEnsure it contains only letters, optional spaces, hyphens, or apostrophes",
                    errorMaxLines: 4,
                    readOnly: _isSaving,
                  ),
                ),
              ],
            )
          ),
        ),
        actions: [
          CustomButtonWidget.secondary(
            text: 'Continue',
            onPressed: _isSaving ? null : _allValid ? _saveUserInfoAndNavigate : null,
            showIsSaving: _isSaving,
          ),
        ]
    );
  }
}