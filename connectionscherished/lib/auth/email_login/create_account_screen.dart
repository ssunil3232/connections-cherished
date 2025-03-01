import 'package:connectionscherished/models/timezone_model.dart';
import 'package:connectionscherished/models/user_model.dart';
import 'package:connectionscherished/routes.dart';
import 'package:connectionscherished/services/routing_service.dart';
import 'package:connectionscherished/services/user_service.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/custom_button_widget.dart';
import 'package:connectionscherished/widgets/form-fields/input_field_widget.dart';
import 'package:connectionscherished/widgets/form-fields/timezone_picker_widget.dart';
import 'package:connectionscherished/widgets/navigation/top_nav_bar_widget.dart';
import 'package:connectionscherished/widgets/page_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'dart:developer' as developer;

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final NavigationService _navService = GetIt.I<NavigationService>();
  final _userService = GetIt.I.get<UserService>();
  final _nameController = TextEditingController();
  final RegExp nameRegex = RegExp(r"^[a-zA-Z0-9_\xC0-\uFFFF]+([ \-']{0,1}[a-zA-Z0-9_\xC0-\uFFFF]+){0,2}[.]{0,1}$");
  bool _allValid = false;
  bool _showNameError = false;
  bool _isSaving = false;
  TimezoneModel selectedTimezone = TimezoneModel(location: '', label: '', offset_hours: '');

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateButtonState);
  }

  bool _isNameValid() {
    final name = _nameController.text.trim();
    if(name.isEmpty) {
      _showNameError = false;
      return false;
    }
    _showNameError = !nameRegex.hasMatch(name);
    return !_showNameError;
  }

  // enable the button when all fields are filled and valid
  void _updateButtonState() {
    setState(() {
      _allValid = _isNameValid() && selectedTimezone.label.isNotEmpty;
    });
  }

  // save user info and navigate to dashboard
  void _saveUserInfoAndNavigate() async {
    // save user info
    UserModel user = UserModel(
      userName: _nameController.text
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
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: TopNavBarWidget(header: const Text(''), showBackButton: false, showBorder: false),
      backgroundColor: GlobalStyles.defaultBg,
      body: PagePadding(
        bottomPadding: GlobalStyles.spacingStates.spacing32,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Row(
                      children: [
                        Text('Welcome!', style: GlobalStyles.textStyles.textH1),
                        Padding(
                          padding: EdgeInsets.only(left: GlobalStyles.spacingStates.spacing16),
                          child: SvgPicture.asset('assets/icons/cheers_icon.svg', width: 32, height: 32),
                        ),
                      ],
                    ),
                    // Name
                    Padding(
                      padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing16),
                      child: InputFieldWidget(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        labelText: 'Your name',
                        placeholderText: 'Jane Doe',
                        errorState: _showNameError,
                        errorText: "❌ Invalid name format. \nEnsure it contains only letters, optional spaces, hyphens, or apostrophes",
                        errorMaxLines: 4,
                        readOnly: _isSaving,
                      ),
                    ),
                    // Timezone
                    Padding(
                      padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing16),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: GlobalStyles.spacingStates.spacing8),
                            child: SvgPicture.asset('assets/icons/timezone_icon.svg', width: 24, height: 24),
                          ),
                          Text('Timezone', style: GlobalStyles.textStyles.textBody.copyWith(color: GlobalStyles.textSubtle)),
                          Expanded(
                            child: TimezonePickerWidget(
                              onChanged: (value) {
                                setState(() {
                                  selectedTimezone = value;
                                });
                                _updateButtonState();
                              },
                            )
                          )
                        ],
                      )
                    ),
                    Center(
                      child: Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              children:[
                                TextSpan(
                                  text: 'Connections Cherished was founded on the innate need for keeping up with social connections with loved ones!',
                                  style: GlobalStyles.textStyles.textBody
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: GlobalStyles.spacingStates.spacing8),
                                    child: SvgPicture.asset('assets/icons/heart_icon.svg', width: 24, height: 24),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: GlobalStyles.spacingStates.spacing16),
                          RichText(
                            text: TextSpan(
                              children:[
                                TextSpan(
                                  text: 'Here’s to making it happen—one\n',
                                  style: GlobalStyles.textStyles.textBody
                                ),
                                TextSpan(
                                  text: 'cherished connection ',
                                  style: GlobalStyles.textStyles.textH3Varaint
                                ),
                                TextSpan(
                                  text: 'at a time!',
                                  style: GlobalStyles.textStyles.textBody
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: GlobalStyles.spacingStates.spacing8),
                                    child: SvgPicture.asset('assets/icons/star_icon.svg', width: 24, height: 24),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    )
                  ]
                )
              ),
              CustomButtonWidget.primary(
                text: "Let's begin!",
                onPressed: !_allValid || _isSaving ? null : _saveUserInfoAndNavigate,
                showIsSaving: _isSaving,
              )
            ]
          ),
        )
      )
    );
  }
}
