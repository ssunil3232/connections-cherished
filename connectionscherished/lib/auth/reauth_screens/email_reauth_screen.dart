import 'package:connectionscherished/services/auth_service.dart';
import 'package:connectionscherished/services/routing_service.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/util/callback.dart';
import 'package:connectionscherished/widgets/custom_button_widget.dart';
import 'package:connectionscherished/widgets/form-fields/input_field_widget.dart';
import 'package:connectionscherished/widgets/navigation/top_nav_bar_widget.dart';
import 'package:connectionscherished/widgets/page_padding.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';


// ignore: must_be_immutable
class EmailReauthScreen extends StatefulWidget {
  final SignInCallback? onSignIn;
  String header;
  String message;
  String buttonText;
  final String email;
  EmailReauthScreen(
      {this.onSignIn,
      this.header = '',
      this.message = '',
      this.buttonText = 'Continue',
      required this.email,
      super.key});

  @override
  _EmailReauthScreenState createState() => _EmailReauthScreenState();
}

class _EmailReauthScreenState extends State<EmailReauthScreen> {
  final _routingService = GetIt.I<NavigationService>();
  final _authService = GetIt.I<AuthService>();
  final _passwordController = TextEditingController();
  bool _isSaving = false;
  bool _isObscure = true;
  bool _allValid = false;
  bool _passwordValidateFailed = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_updateButtonState);
  }

  // validate password is correct
  bool _isPasswordFormatValid() {
    final password = _passwordController.text;
    if(password.isEmpty) {
      return false;
    }
    return (password.length >= 12);
  }

  // enable the button if all fields are valid
  void _updateButtonState() {
    setState(() {
      _allValid = _isPasswordFormatValid();
      _passwordValidateFailed = false;
    });
  }

  void _reauth() async {
    setState(() {
      _isSaving = true;
    });
    try {
      await _authService.reauthenticateWithEmail(
              email: widget.email,
              password: _passwordController.text,
              onSignIn: widget.onSignIn);
    // ignore: unused_catch_clause
    } on Exception catch (e) {
      setState(() {
        _passwordValidateFailed = true;
      });
    } catch (e) {
      _routingService.showPopup("Internal Server Error!",
          color: getSnackbarColor(SnackbarType.alert));
    }
    setState(() {
      _isSaving = false;
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: TopNavBarWidget(
        header: RichText(
          text: TextSpan(
            style: GoogleFonts.juliusSansOne(),
            children: const [
              TextSpan(
                text: 'Delete ',
                style: TextStyle(fontSize: 20, color: Color(0xff8719BB)),
              ),
              TextSpan(
                text: 'account',
                style: TextStyle(fontSize: 20, color: Colors.black87)
              ),
            ],
          ),
        ),
      showBackButton: true, showBorder: true, bgColor: Theme.of(context).colorScheme.inversePrimary,),
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
                    Text(widget.message, style: GlobalStyles.textStyles.body1,),
                    // Password
                    Padding(
                      padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing16),
                      child: InputFieldWidget(
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        labelText: 'Password',
                        placeholderText: '12 characters with symbol or #',
                        errorState: _passwordValidateFailed,
                        errorText: '❌ Wrong Password.',
                        obscureText: _isObscure,
                        suffixIcon: IconButton(
                          icon: VariedIcon.varied(_isObscure ? Symbols.visibility_off_rounded : Symbols.visibility_rounded),
                          onPressed: () => setState(() => _isObscure = !_isObscure),
                        ),
                        readOnly: _isSaving,
                      ),
                    ),
                  ]
                )
              ),
              CustomButtonWidget.primaryAlert(
                  text: widget.buttonText,
                  onPressed: !_allValid || _isSaving ? null : _reauth,
                  showIsSaving: _isSaving,
                  // height: 60,
              )
            ]
          )
        )
      )
    );
  }
}
