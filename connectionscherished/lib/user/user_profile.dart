import 'package:connectionscherished/auth/reauth_screens/email_reauth_screen.dart';
import 'package:connectionscherished/models/user_model.dart';
import 'package:connectionscherished/routes.dart';
import 'package:connectionscherished/services/auth_service.dart';
import 'package:connectionscherished/widgets/dialog_widget.dart';
import 'package:connectionscherished/widgets/list_tile_item.dart';
import 'package:connectionscherished/widgets/custom_button_widget.dart';
import 'package:connectionscherished/widgets/navigation/top_nav_bar_widget.dart';
import 'package:connectionscherished/widgets/page_padding.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

// ignore: must_be_immutable
class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});
  @override
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  bool saving = false;
  final _accountService = GetIt.I.get<AuthService>();
  String? _passwordEmail;
  UserModel ? user;
  bool updateSettings = false;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  loadUser() async {
    user = await _accountService.getLoggedInUser();
    setState(() {
      _passwordEmail = _accountService.getPasswordEmail();
    });
  }

  Future<void> saveChanges() async {
    setState(() {
      saving = true;
    });
    try {
      await _accountService.updateUser(user!);
    } catch (e) {
      Exception('Error saving user settings: $e');
    }
    
    setState(() {
      saving = false;
    });
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBarWidget(
        bgColor: Theme.of(context).colorScheme.inversePrimary,
        header: RichText(
          text: TextSpan(
            style: GoogleFonts.juliusSansOne(),
            children: const [
              TextSpan(
                text: 'Profile ',
                style: TextStyle(fontSize: 20, color: Color(0xff8719BB)),
              ),
              TextSpan(
                text: 'settings',
                style: TextStyle(fontSize: 20, color: Colors.black87)
              ),
            ],
          ),
        ),
        showBackButton: true,
        showBorder: false,
      ),
      body: PagePadding(
        child: Center(
          child: saving
          ? const CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 20,),
                    ListTileItem(
                      icon: VariedIcon.varied(Symbols.person_rounded),
                      text: 'Name',
                      subtitle: user?.userName,
                      showTrailingIcon: false,
                      function: () => {
                      }
                    ),
                    _buildEmailTile(context, _passwordEmail),
                    // _buildPasswordTile(context),
                    ListTileItem(
                      icon: VariedIcon.varied(Symbols.notifications_rounded),
                      text: 'Push Notification',
                      trailingIcon: _notificationSwitch('notification'),
                      function: () => {
                      }
                    ),
                  ],
                ),
                //////////////////Completed details/////////////////////
              Column(
                children: [
                  if(updateSettings)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: CustomButtonWidget.primary(
                      showIsSaving: saving,
                      text: 'Save changes',
                      onPressed: (){
                        saveChanges();
                      },
                    )
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: CustomButtonWidget.primaryAlert(
                      text: 'Delete account',
                      onPressed: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _deleteConfirmationDialog();
                          });
                      },
                    )
                  ),
                  const SizedBox(height: 12.0,)
                ],
              )
            ]
          )
        )
      )
    );
  }

  Widget _notificationSwitch(param) {
    return Switch(
      value: user?.enableNotifications ?? true,
      trackOutlineColor: WidgetStateProperty.resolveWith(
        (final Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return null;
          }

          return Colors.transparent;
        },
      ),
      activeColor: Colors.white,
      activeTrackColor: const Color(0xffB350E1),
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: const Color(0xffD9D9D9),
      onChanged: (bool value) {
        setState(() {
          user?.enableNotifications = value;
          updateSettings = true;
        });
      },
    );
  }

  Widget _buildEmailTile(BuildContext context, String? email) {
    if (email != null && email.isNotEmpty) {
      return ListTileItem(
          icon: VariedIcon.varied(Symbols.email_rounded),
          subtitle: email,
          text: 'Email',
          showTrailingIcon: false,
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
      icon: VariedIcon.varied(Symbols.key_rounded),
      subtitle: '***********',
      text: 'Password',
      showTrailingIcon: false,
      function: () => {
                // Navigator.pushNamed(context, Routes.editUserInfo, arguments: {
                //   'screen': Screen.changePassword,
                // })
      });
  }

  Widget _deleteConfirmationDialog() {
    return DialogWidget(
      header: "Delete account?",
      descriptions: const ["Are you sure you want to stop cherishing your connections?"],
      confirmTitle: "No, don’t delete",
      cancelTitle: "Yes, delete account",
      onResponse: (value){
        !value ? deleteAccount() : null;
      },
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
              Navigator.pushNamed(context, Routes.splash);
            },
          ),
        ),
      );
  }
}
