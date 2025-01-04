import 'package:connectionscherished/auth/email_login/sign_in_screen.dart';
import 'package:connectionscherished/auth/email_login/sign_up_screen.dart';
import 'package:connectionscherished/services/auth_service.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/custom_button_widget.dart';
import 'package:connectionscherished/widgets/form-fields/input_field_widget.dart';
import 'package:connectionscherished/widgets/navigation/top_nav_bar_widget.dart';
import 'package:connectionscherished/widgets/page_padding.dart';
import 'package:flutter/material.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  _EmailLoginScreenState createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final _authService = AuthService();
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
    const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final RegExp regExp = RegExp(emailPattern);
    _showEmailError = !regExp.hasMatch(email);

    return !_showEmailError;
  }
  

  // enable the button when all fields are filled and valid
  void _updateButtonState() {
    setState(() {
      _allValid = _isEmailValid();
    });
  }

  Future<void> _checkAccountStatus() async {
    final String email = _emailController.text;
    setState(() {
      _isSaving = true;
    });
    try {
      bool emailExists = await _authService.checkEmailExists(email);
      if(emailExists){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignInScreen(email: email),
          ),
        );
      }
      else{
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpScreen(email: email),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error checking email: $e');
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
      appBar: TopNavBarWidget(header: const Text(''), showBackButton: true, showBorder: false),
      backgroundColor: GlobalStyles.globalBgDefault,
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
                    SizedBox(height: GlobalStyles.spacingStates.spacing24),
                    Text('Continue with email', style: GlobalStyles.textStyles.heading2,),
                    // Email
                    Padding(
                      padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing16),
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
              CustomButtonWidget.primary(
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
