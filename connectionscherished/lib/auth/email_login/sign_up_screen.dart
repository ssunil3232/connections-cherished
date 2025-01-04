import 'package:connectionscherished/services/auth_service.dart';
import 'package:connectionscherished/services/routing_service.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/custom_button_widget.dart';
import 'package:connectionscherished/widgets/form-fields/input_field_widget.dart';
import 'package:connectionscherished/widgets/navigation/top_nav_bar_widget.dart';
import 'package:connectionscherished/widgets/page_padding.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'dart:developer' as developer;

class SignUpScreen extends StatefulWidget {
  final String email;
  const SignUpScreen({super.key, required this.email});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _authService = AuthService();
  final NavigationService _navService = GetIt.I<NavigationService>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final correctIcon = VariedIcon.varied(Symbols.close_small_rounded, color: GlobalStyles.globalErrorText);
  final incorrectIcon = VariedIcon.varied(Symbols.check_small_rounded, color: GlobalStyles.globalSuccessText);
  final errorTextStyle = GlobalStyles.textStyles.caption1.copyWith(color: GlobalStyles.globalTextSubtle);
  final errorIconSpacing = SizedBox(width: GlobalStyles.spacingStates.spacing8,);
  final passwordWeakIcon = VariedIcon.varied(Symbols.error_rounded, color: GlobalStyles.globalErrorText);
  final passwordSuccessIcon = VariedIcon.varied(Symbols.check_circle_rounded, color: GlobalStyles.globalSuccessText);
  final passwordWeakText = Text('Password strength: weak', style: GlobalStyles.textStyles.body2.copyWith(color: GlobalStyles.globalErrorText));
  final passwordSuccessText = Text('Password strength: excellent', style: GlobalStyles.textStyles.body1);
  final passwordMatchText = Text('Passwords match', style: GlobalStyles.textStyles.body1);
  final passwordDoNotMatchText = Text('Passwords do not match', style: GlobalStyles.textStyles.body2.copyWith(color: GlobalStyles.globalErrorText));

  var errors = <Widget>[];
  bool _isObscure = true;
  bool _allValid = false;
  bool _showPasswordError = false;
  bool _showConfirmPasswordError = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_updateButtonState);
    _confirmPasswordController.addListener(_updateButtonState);
  }

  bool _isPasswordValid() {
    final password = _passwordController.text;
    if (password.isEmpty) {
      _showPasswordError = false;
      return false;
    }
    errors = [];
    bool isLengthValid = password.length >= 12;
    bool hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    bool hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    bool hasSymbolAndNumber = RegExp(r'[-!@#\$&*~]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password);
    bool hasNoSpaces = !password.contains(' ');
    _showPasswordError = !(isLengthValid &&
      hasUppercase &&
      hasLowercase &&
      hasSymbolAndNumber &&
      hasNoSpaces
    );

    errors = [
      Row (children:[passwordWeakIcon, errorIconSpacing, passwordWeakText],),
      buildErrorDetail(!isLengthValid, 'Must be at least 12 characters'),
      buildErrorDetail(!hasUppercase, 'Must have at least one uppercase letter'),
      buildErrorDetail(!hasLowercase, 'Must have at least one lowercase letter'),
      buildErrorDetail(!hasSymbolAndNumber, 'Must have at least one symbol or number'),
      buildErrorDetail(!hasNoSpaces, 'Cannot contain spaces'),
    ];
    return !_showPasswordError;
  }

  Widget buildErrorDetail(bool isCorrect, String text){
    return Row (
      children: [
        isCorrect ? correctIcon : incorrectIcon, 
        errorIconSpacing, 
        Text(text, style: errorTextStyle,)
      ],
    );
  }

  // validate confirm password
  bool _isConfirmPasswordValid() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    if (confirmPassword.isEmpty) {
      _showConfirmPasswordError = false;
      return false;
    }
    _showConfirmPasswordError = password != confirmPassword;
    return !_showConfirmPasswordError;
  }

  // enable the button when all fields are filled and valid
  void _updateButtonState() {
    setState(() {
      _allValid = _isPasswordValid() && _isConfirmPasswordValid();
    });
  }

  void _signUp() async {
    final String email = widget.email;
    final String password = _passwordController.text;
    developer.log('Email: $email, Password: $password');
    setState(() {
      _isSaving = true;
    });
    try {
      await _authService.signUpWithEmail(email: email, password: password);
    // ignore: unused_catch_clause
    } on Exception catch (e) {
      _navService.showPopup("User with credentials, already exist.",
            color: getSnackbarColor(SnackbarType.error));
    } catch (e) {
      _navService.showPopup("Internal Server Error!",
            color: getSnackbarColor(SnackbarType.alert));
    }
    setState(() {
      _isSaving = false;
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                    Text('Create an account', style: GlobalStyles.textStyles.heading2,),
                    Padding(
                      padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing16),
                      child: Text("It seems that you don't have an account yet with us. Please create a password.", style: GlobalStyles.textStyles.body1,)
                    ),
                    // Password
                    Padding(
                      padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing16),
                      child: InputFieldWidget(
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        labelText: 'Password',
                        placeholderText: '12 characters with symbol or #',
                        errorState: _showPasswordError,
                        showErrorText: false,
                        obscureText: _isObscure,
                        suffixIcon: IconButton(
                          icon: VariedIcon.varied(_isObscure ? Symbols.visibility_off_rounded : Symbols.visibility_rounded),
                          onPressed: () => setState(() => _isObscure = !_isObscure),
                        ),
                        readOnly: _isSaving,
                        // enableIMEPersonalizedLearning: false,
                      ),
                    ),
                    // Verify Password
                    Padding(
                      padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing16),
                      child: InputFieldWidget(
                        controller: _confirmPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        labelText: 'Confirm password',
                        placeholderText: '12 characters with symbol or #',
                        errorState: !_showPasswordError && _showConfirmPasswordError && _passwordController.text.isNotEmpty,
                        showErrorText: false,
                        obscureText: _isObscure,
                        suffixIcon: IconButton(
                          icon: VariedIcon.varied(_isObscure ? Symbols.visibility_off_rounded : Symbols.visibility_rounded),
                          onPressed: () => setState(() => _isObscure = !_isObscure),
                        ),
                        readOnly: _isSaving,
                        // enableIMEPersonalizedLearning: false,
                      ),
                    ),
                    SizedBox(height: GlobalStyles.spacingStates.spacing16,),
                    if(_showPasswordError) Column(children: errors),
                    if (_passwordController.text.isNotEmpty && !_showPasswordError)
                      Row (children:[passwordSuccessIcon, errorIconSpacing, passwordSuccessText],),
                    SizedBox(height: GlobalStyles.spacingStates.spacing8,),
                    if(!_showPasswordError && _showConfirmPasswordError && _passwordController.text.isNotEmpty && _confirmPasswordController.text.isNotEmpty)
                      Row (children:[passwordWeakIcon, errorIconSpacing, passwordDoNotMatchText],),
                    if(!_showPasswordError && !_showConfirmPasswordError && _passwordController.text.isNotEmpty && _confirmPasswordController.text.isNotEmpty)
                      Row (children:[passwordSuccessIcon, errorIconSpacing, passwordMatchText],)
                  ]
                )
              ),
              CustomButtonWidget.primary(
                text: 'Continue',
                onPressed: !_allValid || _isSaving ? null : _signUp,
                showIsSaving: _isSaving,
              )
            ]
          ),
        )
      )
    );
  }
}
