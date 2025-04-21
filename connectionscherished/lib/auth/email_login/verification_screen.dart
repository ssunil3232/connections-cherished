import 'dart:async';
import 'package:connectionscherished/services/auth_service.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/custom_button_widget.dart';
import 'package:connectionscherished/widgets/form-fields/otp_field_widget.dart';
import 'package:connectionscherished/widgets/navigation/top_nav_bar_widget.dart';
import 'package:connectionscherished/widgets/page_padding.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountVerificationScreen extends StatefulWidget {
  const AccountVerificationScreen({super.key, required this.email});
  final String email;

  @override
  State<AccountVerificationScreen> createState() => _AccountVerificationScreenState();
}

class _AccountVerificationScreenState extends State<AccountVerificationScreen> {
  final SupabaseClient _supaAuthService = Supabase.instance.client;
  final _authService = AuthService();
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
    setUpTimer();
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

  _resentVerificationCode() async{
    await _supaAuthService.auth.signInWithOtp(email: widget.email);
    setUpTimer();
  }

  // validate the SMS code
  void verifyCode() async {
    setState(() {
      disabledOtpField = true;
    });
    try {
      final AuthResponse res = await _supaAuthService.auth.verifyOTP(
        type: OtpType.email,
        token: otpResult,
        email: widget.email,
      );
      await _authService.checkIfUserExists(userId: res.user!.id, userCred: res.user!, loginMethod: SignInMethod.email);
    } on AuthException catch (e) {
    // catch any authentication errors
      debugPrint(e.message);
      Navigator.pop(context);
      // return false;
    } catch (error) {
      // catch any other errors
      Navigator.pop(context);
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
      appBar: TopNavBarWidget(header: const Text(''), height: 100.0,  showBackButton: true, showBorder: false, bgColor: GlobalStyles.defaultBg,),
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
                    Text('Verify your email', style: GlobalStyles.textStyles.textH1,),
                    Padding(
                      padding: EdgeInsets.only(top: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing12)),
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'We want to make sure it’s you. Enter the 6-digit code we sent to ',
                              style: GlobalStyles.textStyles.textBody,
                            ),
                            TextSpan(
                              text: widget.email,
                              style: GlobalStyles.textStyles.textBody.copyWith(
                                fontWeight: FontWeight.w600,
                                color: GlobalStyles.btnBorderPrimary
                              )
                            ),
                            TextSpan(
                              text: '.',
                              style: GlobalStyles.textStyles.textBody,
                            ),
                          ]
                        )
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
                              _resentVerificationCode();
                            }, 
                            text: 'Resend code'
                          )
                          : Text(_timerText, style: GlobalStyles.textStyles.textBody.copyWith(color: GlobalStyles.textSubtle),)
                      )
                  ]
                )
              ),
              CustomButtonWidget.primary(
                  text: 'Continue',
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
