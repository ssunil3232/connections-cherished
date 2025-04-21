import 'package:connectionscherished/auth/email_login/verification_screen.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/custom_button_widget.dart';
import 'package:connectionscherished/widgets/form-fields/input_field_widget.dart';
import 'package:connectionscherished/widgets/navigation/top_nav_bar_widget.dart';
import 'package:connectionscherished/widgets/page_padding.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  EmailLoginScreenState createState() => EmailLoginScreenState();
}

class EmailLoginScreenState extends State<EmailLoginScreen> {
  final SupabaseClient _supaAuthService = Supabase.instance.client;
  final _emailController = TextEditingController();
  bool _isSaving = false;
  bool _allValid = false;
  bool _showEmailError = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
  }

  // validate email format
  bool _isEmailValid() {
    final email = _emailController.text;
    if (email.isEmpty) {
      _showEmailError = false;
      return false;
    }
    _showEmailError = !EmailValidator.validate(email);
    // const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    // final RegExp regExp = RegExp(emailPattern);
    // _showEmailError = !regExp.hasMatch(email);
    return !_showEmailError;
  }
  
  // enable the button when all fields are filled and valid
  void _updateButtonState() {
    setState(() {
      _allValid = _isEmailValid();
    });
  }

  Future<void> _checkAccountStatus() async {
    final String email = _emailController.text.trim();
    setState(() {
      _isSaving = true;
    });
    try {
      await Future.delayed(const Duration(seconds: 2));
      await _supaAuthService.auth.signInWithOtp(email: email);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AccountVerificationScreen(email: email),
        ),
      );
      // bool emailExists = await _authService.checkEmailExists(email);
      // if(emailExists){
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => SignInScreen(email: email),
      //     ),
      //   );
      // }
      // else{
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => SignUpScreen(email: email),
      //     ),
      //     // MaterialPageRoute(
      //     //   builder: (context) => AccountVerificationScreen(),
      //     //   settings: RouteSettings(
      //     //     arguments: {
      //     //       'email': email,
      //     //     },
      //     //   ),
      //     // ),
      //   );
      // }
    } catch (e) {
      Exception('Error checking email: $e');
    }
    setState(() {
      _isSaving = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: TopNavBarWidget(
        header: const Text(''), 
        height: 100.0,
        showBackButton: true, 
        showBorder: false,
        bgColor: GlobalStyles.defaultBg,
      ),
      backgroundColor: GlobalStyles.defaultBg,
      body: PagePadding(
        bottomPadding: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing32, useWidth: false),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Text('Continue with email', style: GlobalStyles.textStyles.textH1),
                    Padding(
                      padding: EdgeInsets.only(top: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing12)),
                      child: Text('Enter a valid email address to login/sign up and a verification code will be sent to you shortly.', style: GlobalStyles.textStyles.textBody,)
                    ),
                    // Email
                    Padding(
                      padding: EdgeInsets.only(top: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing16, useWidth: false),),
                      child: InputFieldWidget(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        labelText: 'Email',
                        placeholderText: 'janedoe@email.com',
                        errorState: _showEmailError,
                        errorText: "Please enter a valid email address",
                        readOnly: _isSaving,
                      ),
                    ),
                  ]
                )
              ),
              CustomButtonWidget.secondary(
                text: 'Continue',
                onPressed: !_allValid || _isSaving ? null : _checkAccountStatus,
                showIsSaving: _isSaving,
              )   
            ]
          )
        )
      )
    );
  }
}
