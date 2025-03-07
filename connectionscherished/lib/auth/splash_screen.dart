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
              Text(
                'Connections Cherished',
                style: GlobalStyles.textStyles.titleHeader,
              ),
              Image.asset(
                'assets/images/logo.png',
                width: 205,
                height: 194,
              ),
              SizedBox(height: GlobalStyles.spacingStates.spacing8),
              Text(
                'Building relationships a \nconnection at a time',
                textAlign: TextAlign.center,
                style: GlobalStyles.textStyles.textBody
              ),
            ]
          )
        ),
      )
    );
  }
}
