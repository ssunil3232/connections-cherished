import 'dart:async';
import 'package:connectionscherished/services/auth_service.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/util/phone_mask_util.dart';
import 'package:connectionscherished/widgets/custom_button_widget.dart';
import 'package:connectionscherished/widgets/form-fields/otp_field_widget.dart';
import 'package:connectionscherished/widgets/navigation/top_nav_bar_widget.dart';
import 'package:connectionscherished/widgets/page_padding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

// ignore: must_be_immutable
class PhoneVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  const PhoneVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<PhoneVerificationScreen> createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final _authService = AuthService();
  final _firebaseAuthService = FirebaseAuth.instance;
  String otpResult = '';
  bool processingOtp = false;
  bool _showResendCode = false;
  String _timerText = '';
  String _verificationId = '';
  bool disabledOtpField = true;


  bool _allValid = false;
  Timer? _smsCodeTimer;
  final _totalTime = 30;

  @override
  void initState() {
    super.initState();
    _sendSMSCode();
  }

  void _sendSMSCode() async {
    int timeLeft = _totalTime;
    final phoneNumber = widget.phoneNumber;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _firebaseAuthService.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          developer.log('The provided phone number is not valid.');
          Navigator.pop(context, true);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        // Update the UI and start the countdown
        setState(() {
          disabledOtpField = false;
          processingOtp = false;
          _showResendCode = false;
          timeLeft = _totalTime;
          _timerText = '$timeLeft sec';
        });
        _smsCodeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (timeLeft == 1) {
            timer.cancel();
            setState(() {
              _showResendCode = true;
            });
          } else {
            setState(() {
              timeLeft--;
              _timerText = '$timeLeft sec';
            });
          }
        });
        _verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        developer.log('Code Auto Retrieval Timeout');
      },
    );
  }

  // validate the SMS code
  void verifySMSCode() async {
    setState(() {
      processingOtp = true;
    });
    try {
        await _authService.signInWithPhoneNumber(_verificationId, otpResult);
    } catch (e){
      developer.log("verification failed");
      setState(() {
        processingOtp = false;
      });
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
    _smsCodeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: TopNavBarWidget(header: const Text(''), showBackButton: true, showBorder: false,),
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
                    Text('Verify your phone', style: GlobalStyles.textStyles.heading2,),
                    Padding(
                      padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing16),
                      child: Text("We just sent you an SMS. Enter the \nverification code sent to ${phoneNumberMask(widget.phoneNumber)}", style: GlobalStyles.textStyles.body1,)
                    ),
                    // OTP Field
                    Padding(
                      padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing16),
                      child: OtpFieldWidget(
                        processingOtp: processingOtp || disabledOtpField,
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
                    SizedBox(height: GlobalStyles.spacingStates.spacing16,),
                    if(!processingOtp)
                      Align(
                        alignment: Alignment.centerRight,
                        child: _showResendCode ? 
                          CustomButtonWidget.tertiary(
                            onPressed: (){
                              _sendSMSCode();
                            }, 
                            text: 'Resend code'
                          )
                          : Text(_timerText, style: GlobalStyles.textStyles.body1.copyWith(color: GlobalStyles.globalTextSubtle),)
                      )
                  ]
                )
              ),
              CustomButtonWidget.primary(
                  text: 'Continue',
                  onPressed: processingOtp ? null : _allValid ? verifySMSCode : null,
                  showIsSaving: processingOtp,
              ),
            ]
          )
        )
      ),
    );
  }
}
