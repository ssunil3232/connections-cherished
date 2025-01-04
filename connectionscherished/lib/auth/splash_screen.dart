import 'dart:async';
import 'package:connectionscherished/services/auth_service.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/page_padding.dart';
import 'package:flutter/material.dart';
// The SplashScreen class is a StatefulWidget that checks the user's authentication status
// and navigates to either the landing page or the dashboard accordingly.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _authService = AuthService();
  final _waitingTime = const Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  // check the authentication state of the user
  void _checkAuthState() async {
    Timer(_waitingTime, () {
      // _authService.getUser('v2JcJl0Q8w7fIF52uJyM');
      _authService.checkSplashState();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PagePadding(
        bottomPadding: 64,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo_clear.png',
                width: 150,
              ),
              const SizedBox(height: 16),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Building ',
                  style: GlobalStyles.textStyles.titular.copyWith(color: GlobalStyles.globalTextSubtle),
                  children: [
                    TextSpan(
                      text: 'relationships\n',
                      style: GlobalStyles.textStyles.titular.copyWith(color: GlobalStyles.brandColor1)
                    ),
                    TextSpan(
                      text: 'a ',
                      style: GlobalStyles.textStyles.titular.copyWith(color: GlobalStyles.globalTextSubtle)
                    ),
                    TextSpan(
                      text: 'connection ',
                      style: GlobalStyles.textStyles.titular.copyWith(color: GlobalStyles.brandColor2)
                    ),
                    TextSpan(
                      text: 'at a time.',
                      style: GlobalStyles.textStyles.titular.copyWith(color: GlobalStyles.globalTextSubtle)
                    ),
                  ]
                )
              ),
            ]
          )
        ),
      )
    );
  }
}
