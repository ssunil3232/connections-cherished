import 'dart:async';
import 'package:connectionscherished/services/auth_service.dart';
import 'package:connectionscherished/services/routing_service.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/util/callback.dart';
import 'package:connectionscherished/widgets/custom_button_widget.dart';
import 'package:connectionscherished/widgets/form-fields/otp_field_widget.dart';
import 'package:connectionscherished/widgets/navigation/top_nav_bar_widget.dart';
import 'package:connectionscherished/widgets/page_padding.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ignore: must_be_immutable
class AccountReauthScreen extends StatefulWidget {
  AccountReauthScreen({
    super.key, 
    this.onReauth,
    this.header = '',
    this.message = '',
    this.buttonText = 'Continue',
    required this.email,
  });
  final SignInCallback? onReauth;
  String header;
  String message;
  String buttonText;
  final String email;

  @override
  State<AccountReauthScreen> createState() => _AccountReauthScreenState();
}

class _AccountReauthScreenState extends State<AccountReauthScreen> {
  final SupabaseClient _supaAuthService = Supabase.instance.client;
  final _authService = AuthService();
  final _routingService = GetIt.I<NavigationService>();
  String otpResult = '';
  bool _showResendCode = false;
  String _timerText = '';
  bool disabledOtpField = false;
  bool _allValid = false;
  Timer? _otpCodeTimer;
  final _totalTime = 30;

  @override
  void initState() {
    super.initState();
   sendVerificationCode();
  }

  setUpTimer(){
    int timeLeft = _totalTime;
    setState(() {
      _timerText = 'Request a new code in $timeLeft seconds';
    });
    _otpCodeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (timeLeft == 1) {
          timer.cancel();
          setState(() {
            _showResendCode = true;
          });
        } else {
          setState(() {
            timeLeft--;
            _timerText = 'Request a new code in $timeLeft seconds';
          });
        }
      }
    );
  }

  sendVerificationCode() async{
    await _supaAuthService.auth.reauthenticate();
    setUpTimer();
  }

  // validate the SMS code
  void verifyCode() async {
    setState(() {
      disabledOtpField = true;
    });
    try {
      await _authService.reauthenticateAccount(
        email: widget.email,
        otpType: OtpType.email,
        otpResult: otpResult,
        onReauth: widget.onReauth
      );
    } on AuthException catch (e) {
    // catch any authentication errors
      Navigator.pop(context);
      _routingService.showPopup(e.message,
          color: getSnackbarColor(SnackbarType.alert));
      // return false;
    } catch (error) {
      // catch any other errors
      _routingService.showPopup("Internal Server Error!",
          color: getSnackbarColor(SnackbarType.error));
    }
  }

  // enable the verification button when all fields are valid
  void _updateButtonState() {
    setState(() {
      _allValid = otpResult !='';
    });
  }

  @override
  void dispose() {
    _otpCodeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: TopNavBarWidget(
        header: Text(widget.header, style: GlobalStyles.textStyles.titleHeader),
        showBackButton: true, 
        showBorder: false,
        height: 100,
      ),
      backgroundColor: GlobalStyles.defaultBg,
      body: PagePadding(
        bottomPadding: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing32),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing24)),
                      child: Text(
                        widget.message,
                        style: GlobalStyles.textStyles.textBody.copyWith(color: GlobalStyles.textSubtle),
                      )
                    ),
                    // OTP Field
                    Padding(
                      padding: EdgeInsets.only(top: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing16)),
                      child: OtpFieldWidget(
                        processingOtp: disabledOtpField,
                        inComplete: (isIncomplete) {
                          setState(() {
                            otpResult = '';
                          });
                          _updateButtonState();
                        },
                        onCompleted: (value) {
                          setState(() {
                            otpResult = value;
                          });
                          _updateButtonState();
                        },
                      )
                    ),
                    SizedBox(height: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing16)),
                    if(!disabledOtpField)
                      Align(
                        alignment: Alignment.centerRight,
                        child: _showResendCode ? 
                          CustomButtonWidget.tertiary(
                            onPressed: (){
                              sendVerificationCode();
                            }, 
                            text: 'Resend code'
                          )
                          : Text(_timerText, style: GlobalStyles.textStyles.textBody.copyWith(color: GlobalStyles.textSubtle),)
                      )
                  ]
                )
              ),
              CustomButtonWidget.primary(
                  text: widget.buttonText,
                  onPressed: disabledOtpField ? null : _allValid ? verifyCode : null,
                  showIsSaving: disabledOtpField,
              ),
            ]
          )
        )
      ),
    );
  }
}
