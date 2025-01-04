import 'package:connectionscherished/routes.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/custom_button_widget.dart';
import 'package:connectionscherished/widgets/page_padding.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class AuthOptionsScreen extends StatefulWidget {
  const AuthOptionsScreen({super.key});

  @override
  AuthOptionsScreenState createState() => AuthOptionsScreenState();
}

class AuthOptionsScreenState extends State<AuthOptionsScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: TopNavBarWidget(header: const Text(''), showBackButton: false, showBorder: false,),
      backgroundColor: GlobalStyles.globalBgDefault,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB5A2EC),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: PagePadding(
        bottomPadding: GlobalStyles.spacingStates.spacing32,
        child: Center( // Wrap with Center widget
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildLogoAndText(),
              ),
              Column(children: [
              // Continue with phone
              // CustomButtonWidget.secondary(
              //   text: 'Continue with Phone',
              //   onPressed: (){
              //     Navigator.pushNamed(context, Routes.phoneOption);
              //   },
              //   // height: 56,
              //   icon: Symbols.ad_units_rounded,
              // ),
              // SizedBox(
              //   height: GlobalStyles.spacingStates.spacing24,
              // ),
              // Continue with email
              CustomButtonWidget.secondary(
                text: 'Continue with Email',
                onPressed: (){
                  Navigator.pushNamed(context, Routes.emailOption);
                },
                // height: 52,
                icon: Symbols.email_rounded,
              ),
              SizedBox(
                height: GlobalStyles.spacingStates.spacing24,
              )
               ],)
            ]
          )
        )
      ),
      )
    );
  }

  Widget _buildLogoAndText() {
    return Center(
      heightFactor: 0.5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo_clear.png',
          width: 95,
        ),
        SizedBox(height: GlobalStyles.spacingStates.spacing8,),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Connections ',
            style: GlobalStyles.textStyles.titular.copyWith(color: GlobalStyles.brandColor1),
            children: [
              TextSpan(
                text: 'Cherished',
                style: GlobalStyles.textStyles.titular.copyWith(color: GlobalStyles.brandColor2)
              ),
            ]
          )
        ),
        SizedBox(height: GlobalStyles.spacingStates.spacing24,),
      ]
    ));
  }
}
