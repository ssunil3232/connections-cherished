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
                  // SizedBox(
                  //   height: GlobalStyles.spacingStates.spacing24,
                  // ),
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
}
