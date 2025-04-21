import 'dart:io';

import 'package:connectionscherished/routes.dart';
import 'package:connectionscherished/services/auth_service.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/bottom_drawer_widget.dart';
import 'package:connectionscherished/widgets/custom_button_widget.dart';
import 'package:connectionscherished/widgets/page_padding.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class AuthOptionsScreen extends StatefulWidget {
  const AuthOptionsScreen({super.key});

  @override
  AuthOptionsScreenState createState() => AuthOptionsScreenState();
}

class AuthOptionsScreenState extends State<AuthOptionsScreen> {
  final _authService = GetIt.I.get<AuthService>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalStyles.defaultBg,
      body: PagePadding(
        bottomPadding: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildLogoAndText(),
              ),
              Column(
                children: [
                  // Continue with email
                  CustomButtonWidget.primary(
                    text: 'Continue with email',
                    onPressed: (){
                      Navigator.pushNamed(context, Routes.emailOption);
                    },
                    icon: Symbols.email_rounded,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            color: GlobalStyles.defaultBorder,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing8)),
                          child: Text(
                            'or',
                            style: GlobalStyles.textStyles.textBody,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: GlobalStyles.defaultBorder,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing28, useWidth: true),
                    children: [
                      Visibility(
                        visible: Platform.isIOS,
                        child: CustomButtonWidget.appleBtn(
                          text: 'Continue with Apple',
                          onPressed: (){
                            // _authService.signInWithApple();
                          },
                          // height: 56,
                        ),
                      ),
                      // Continue with Google
                      CustomButtonWidget.googleBtn(
                        text: 'Continue with Google',
                        onPressed: () async{
                          await _authService.signInWithGoogle();
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing16)),
                    child: termsAndConditions()
                  )
                ],
              )
            ]
          )
        )
      )
    );
  }

  Widget _buildLogoAndText() {
    return Center(
      heightFactor: 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Connections Cherished',
            style: GlobalStyles.textStyles.titleHeader,
          ),
          Image.asset(
            'assets/images/logo.png',
            width: 205,
            height: 194,
          ),
          SizedBox(height: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing8)),
          Text(
            'Building relationships a \nconnection at a time',
            textAlign: TextAlign.center,
            style: GlobalStyles.textStyles.textBody
          ),
        ]
      )
    );
  }

  Widget termsAndConditions(){
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'By continuing, you agree to our ',
        style: GlobalStyles.textStyles.textCaption1,
        children: [
          _clickableText(text: 'Terms of Privacy Policy', title: 'Privacy Terms and Conditions', modalWidget: _privacyPolicy()),
          TextSpan(
            text: '.',
            style: GlobalStyles.textStyles.textCaption1,
          )
        ]
      )
    );
  }

  TextSpan _clickableText({required String text, required String title, required Widget modalWidget}) {
    return TextSpan(
      text: text,
      style: GlobalStyles.textStyles.textCaption1.copyWith(
        color: GlobalStyles.btnBorderPrimary,
        // decoration: TextDecoration.underline,
        // decorationColor: GlobalStyles.btnBorderPrimary
      ),
      recognizer: TapGestureRecognizer()
      ..onTap = () async {
        openBottomSheet(
          context: context,
          header: title,
          heightFactor: 0.8,
          body: modalWidget
        );
      },
    );
  }

  Widget _privacyPolicy(){
    return Text('abc');
  }
}
