import 'package:connectionscherished/auth/reauth_screens/email_reauth_screen.dart';
import 'package:connectionscherished/models/user_model.dart';
import 'package:connectionscherished/routes.dart';
import 'package:connectionscherished/services/auth_service.dart';
import 'package:connectionscherished/services/util_service.dart';
import 'package:connectionscherished/styles/button_styles.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/bottom_drawer_widget.dart';
import 'package:connectionscherished/widgets/dialog_widget.dart';
import 'package:connectionscherished/widgets/form-fields/input_field_widget.dart';
import 'package:connectionscherished/widgets/form-fields/switch_widget.dart';
import 'package:connectionscherished/widgets/form-fields/timezone_picker_widget.dart';
import 'package:connectionscherished/widgets/list_tile_item.dart';
import 'package:connectionscherished/widgets/custom_button_widget.dart';
import 'package:connectionscherished/widgets/navigation/top_nav_bar_widget.dart';
import 'package:connectionscherished/widgets/page_padding.dart';
import 'package:connectionscherished/widgets/profile/profile_img_name_dialog.dart';
import 'package:connectionscherished/widgets/profile/profile_img_name_update.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

// ignore: must_be_immutable
class UserProfileScreen extends StatefulWidget {
  UserModel ? user;
  
  UserProfileScreen({super.key, this.user});
  @override
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  bool saving = false;
  bool showSaveBtn = false;
  final _accountService = GetIt.I.get<AuthService>();
  final _utilService = GetIt.I.get<UtilService>();
  final _authService = FirebaseAuth.instance;
  String? _passwordEmail;
  final _messageController = TextEditingController();
  AvatarImgSelection userProfile = AvatarImgSelection(
    name: 'John Doe', 
    img: 'assets/images/avatars/avatar1.png', 
  );

  @override
  void initState() {
    super.initState();
    // if(mounted){
      setState(() {
        showSaveBtn = false;
      });
      loadUserSettings();
    // }
  }

  Future<void> loadUserSettings() async {
    userProfile = AvatarImgSelection(
      name: widget.user?.userName ?? 'John Doe', 
      img: widget.user?.profileImage ?? 'assets/images/avatars/avatar1.png', 
    );
    debugPrint('User: ${widget.user?.timezone}');
    if (mounted) {
      setState(() {
        _passwordEmail = _accountService.getPasswordEmail();
        _messageController.text = widget.user?.message ?? 'Free for a quick catch up?';
      });
    }
  }

  updateProfileData (AvatarImgSelection data){
    if (mounted) {
      setState(() {
        widget.user?.userName = data.name;
        widget.user?.profileImage = data.img;
        userProfile = data;
        showSaveBtn = true;
      });
    }
  }

  Future<void> saveChanges() async {
    widget.user?.message = _messageController.text;
    FocusScope.of(context).unfocus();
    if (mounted) {
      setState(() {
        saving = true;
      });
      try {
        await _utilService.uploadImage(userProfile, widget.user?.userId ?? '');
        await _accountService.updateUser(widget.user!);
      } catch (e) {
        Exception('Error saving user settings: $e');
      }
      setState(() {
        saving = false;
      });
      Navigator.pop(context);
    }
  }

  void logout() async {
    await _authService.signOut();
    Navigator.pushNamedAndRemoveUntil(context, Routes.authOptions, (route) => false);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBarWidget(
        showBorder: false,
        height: 100.0,
        header: Text("Profile", style: GlobalStyles.textStyles.titleHeader),
        showBackButton: true,
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: logout,
                icon: VariedIcon.varied(Symbols.logout_rounded),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text('Logout', style: GlobalStyles.textStyles.textCaption3,),
              )
            ],
          )
        ],
      ),
      body: PagePadding(
        bottomPadding: GlobalStyles.spacingStates.spacing32,
        child: saving
          ? Center(
              child: const CircularProgressIndicator()
            )
          : GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      SizedBox(height: GlobalStyles.spacingStates.spacing24),
                      ProfileImgNameUpdate(
                        onUpdate: (value) => updateProfileData(value),
                        avatar: userProfile,
                        isEditEnabled: true,
                      ),
                      SizedBox(height: GlobalStyles.spacingStates.spacing20),
                      Stack(
                        children: [
                          IntrinsicWidth(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Account settings', 
                                  style: GlobalStyles.textStyles.textCaption1,
                                ),
                                Container(
                                  height: 0.5,
                                  color: GlobalStyles.primaryText,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: GlobalStyles.spacingStates.spacing16),
                      Column(
                        spacing: GlobalStyles.spacingStates.spacing8,
                        children: [
                          _buildEmailTile(context, _passwordEmail),
                          _buildPasswordTile(context),
                          _notificationSwitch(),
                          _timezoneSetting(),
                          _schedulerSetting(),
                          SizedBox(height: GlobalStyles.spacingStates.spacing4),
                          _messageSetting()
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomButtonWidget.tertiaryVariant(
                        text: 'Save changes',
                        showUnderline: false,
                        isEnabled: showSaveBtn && !saving,
                        onPressed: (){
                          saveChanges();
                        },
                      ),
                      CustomButtonWidget.tertiaryAlert(
                        text: 'Delete account',
                        onPressed: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return _deleteConfirmationDialog();
                            }
                          );
                        },
                      )
                    ],
                  )
                )
              ],
            )
          )
        )
    );
  }

  Widget _notificationSwitch() {
    return Row(
      crossAxisAlignment:CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: GlobalStyles.spacingStates.spacing8),
          child: SvgPicture.asset('assets/icons/notification_icon.svg', width: 24, height: 24),
        ),
        Text(
          'Notification alert',
          style: GlobalStyles.textStyles.textBody
        ),
        SizedBox(width: GlobalStyles.spacingStates.spacing12),
        Container(
          margin: EdgeInsets.only(left:GlobalStyles.spacingStates.spacing4),
          child: SwitchWidget(
            isDisabled: false,
            initialState: widget.user?.enableNotifications ?? true,
            onChange: (value) {
              if(mounted){
                setState(() {
                  widget.user?.enableNotifications = value;
                  showSaveBtn = true;
                });
              }
            },
          )
        ),
        Padding(
          padding: EdgeInsets.only(left: GlobalStyles.spacingStates.spacing8),
          child: IconButton(
            onPressed: (){
              openBottomSheet(
                context: context,
                header:'Notification alerts',
                heightFactor: 0.25,
                body: Text(
                  "Switch on/off all alerts reminding you of your connections and scheduled messages.",
                  style: GlobalStyles.textStyles.textCaption1
                ),
              );
            }, 
            icon: VariedIcon.varied(Symbols.info_rounded, size: 28, weight: 300, color: GlobalStyles.defaultBorder),
          )
        ),
      ],
    );
  }

  Widget _timezoneSetting() {
    return Row(
      crossAxisAlignment:CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: GlobalStyles.spacingStates.spacing8),
          child: SvgPicture.asset('assets/icons/timezone_icon.svg', width: 24, height: 24),
        ),
        Text(
          'Timezone',
          style: GlobalStyles.textStyles.textBody
        ),
        SizedBox(width: GlobalStyles.spacingStates.spacing12),
        Expanded(
          child: TimezonePickerWidget(
            isDisabled: false,
            initialTimezone: widget.user?.timezone,
            onChanged: (value) {
              if(mounted){
                setState(() {
                  widget.user?.timezone = value.location;
                  showSaveBtn = true;
                });
              }
            },
          )
        )
      ],
    );
  }

  Widget _schedulerSetting() {
    return Row(
      crossAxisAlignment:CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: GlobalStyles.spacingStates.spacing8),
          child: SvgPicture.asset('assets/icons/scheduler_icon.svg', width: 24, height: 24),
        ),
        FilledButton(
          style: ButtonStyles.tertiaryButton.copyWith(
            backgroundColor: WidgetStatePropertyAll(GlobalStyles.topNavBg),
            padding: WidgetStatePropertyAll(EdgeInsets.all(GlobalStyles.spacingStates.spacing8)),
          ),
          onPressed: (){
            // Navigate to scheduler screen
          }, 
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Schedule', style: GlobalStyles.textStyles.textButtonSecondary), 
              SizedBox(width: GlobalStyles.spacingStates.spacing20),
              VariedIcon.varied(Symbols.arrow_forward_ios_rounded, size: 24, weight: 300, color: GlobalStyles.primaryText),
            ],
          ),
        ),
      ],
    );
  }

  Widget _messageSetting() {
    return Row(
      crossAxisAlignment:CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: GlobalStyles.spacingStates.spacing8),
          child: SvgPicture.asset('assets/icons/message_icon.svg', width: 24, height: 24),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Scheduler message',
              style: GlobalStyles.textStyles.textBody
            ),
            SizedBox(height: GlobalStyles.spacingStates.spacing4),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right:GlobalStyles.spacingStates.spacing8),
                  child: SwitchWidget(
                    isDisabled: false,
                    initialState: widget.user?.enableAi ?? false,
                    onChange: (value) {
                      if(mounted){
                        setState(() {
                          widget.user?.enableAi = value;
                          showSaveBtn = true;
                        });
                      }
                    },
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(right: GlobalStyles.spacingStates.spacing4),
                  child: SvgPicture.asset('assets/icons/ai_icon.svg', width: 24, height: 24),
                ),
                Text(
                  'Ai generated',
                  style: GlobalStyles.textStyles.textCaption1.copyWith(color: GlobalStyles.textSubtle),
                ),
                Padding(
                  padding: EdgeInsets.only(left: GlobalStyles.spacingStates.spacing8),
                  child: IconButton(
                    onPressed: (){
                      openBottomSheet(
                        context: context,
                        header:'Ai use disclaimer',
                        heightFactor: 0.38,
                        body: Text(
                          "Enabling this tool means allowing the use of AI to craft messages to send to your connections, based on your journal entries."
                          " While we strive to capture your thoughts and emotions accurately, please review the message before sending "
                          "to ensure it reflects your true intent. AI-generated messages do not replace personal expression, and you " 
                          "remain responsible for the content shared.",
                          style: GlobalStyles.textStyles.textCaption1
                        ),
                      );
                    }, 
                    icon: VariedIcon.varied(Symbols.info_rounded, size: 28, weight: 300, color: GlobalStyles.defaultBorder),
                  )
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing4),
              child: SizedBox(
                height: 80,
                width: MediaQuery.of(context).size.width * 0.8,
                child: InputFieldWidget(
                  controller: _messageController,
                  keyboardType: TextInputType.multiline,
                  placeholderText: 'Customize your scheduler message',
                  readOnly: saving || widget.user?.enableAi == true,
                  multilineHeight: 80,
                ),
              )
            ),
          ],
        )
      ],
    );
  }

  Widget _buildEmailTile(BuildContext context, String? email) {
    if (email != null && email.isNotEmpty) {
      return ListTileItem(
          icon: SvgPicture.asset('assets/icons/email_icon.svg', width: 24, height: 24),
          subtitle: email,
          text: 'Email',
          showTrailingIcon: true,
          function: () => {
                // Navigator.pushNamed(context, Routes.editUserInfo,
                // arguments: {
                //   'screen': Screen.editEmail,
                // })
              });
    } else {
      return Container();
    }
  }

  // ignore: unused_element
  Widget _buildPasswordTile(BuildContext context) {
    return ListTileItem(
      icon: SvgPicture.asset('assets/icons/password_icon.svg', width: 24, height: 24),
      subtitle: '***********',
      text: 'Password',
      showTrailingIcon: true,
      function: () => {
                // Navigator.pushNamed(context, Routes.editUserInfo, arguments: {
                //   'screen': Screen.changePassword,
                // })
      });
  }

  Widget _deleteConfirmationDialog() {
    return DialogWidget(
      descriptions: const ["Are you sure you want to\ndelete your account?"],
      confirmTitle: "No, don’t delete",
      cancelTitle: "Yes, delete account",
      onResponse: (value){
        !value ? deleteAccount() : null;
      },
      image: Image.asset(
        "assets/images/sad-face.png",
        width: 150,
        height: 150,
      ),
      isWarning: true,
    );
  }

  void deleteAccount() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmailReauthScreen(
          email: _passwordEmail!,
          header: 'Delete account',
            message: 'Please enter your password to confirm account deletion.',
            buttonText: 'Confirm delete',
            onSignIn: (credential) async {
              await _accountService.deleteAccount(credential);
              if (mounted) {
                Navigator.pushNamed(context, Routes.splash);
              }
            },
          ),
        ),
      );
  }
}
