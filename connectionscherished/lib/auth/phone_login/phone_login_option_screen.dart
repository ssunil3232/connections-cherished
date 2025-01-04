import 'package:connectionscherished/auth/phone_login/phone_verification_screen.dart';
import 'package:connectionscherished/services/routing_service.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/custom_button_widget.dart';
import 'package:connectionscherished/widgets/form-fields/dropdown_widget.dart';
import 'package:connectionscherished/widgets/form-fields/input_field_widget.dart';
import 'package:connectionscherished/widgets/navigation/top_nav_bar_widget.dart';
import 'package:connectionscherished/widgets/page_padding.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'dart:developer' as developer;

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final NavigationService _navService = GetIt.I<NavigationService>();
  final _countryCodes = ['+1', '+86', '+966']; // US, China, Saudi Arabia
  final _phoneNumberLength = {"+1": 10,"+86": 11,'+966': 9};
  String _selectedCountryCode = '+1'; // Default country code
  final _phoneNumberController = TextEditingController();
  String _phoneNumber = '';
  bool _allValid = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _phoneNumberController.addListener(_updateButtonState);
  }

  bool _phoneNumberComplete(){
    int phoneNumberLengthRequired = _phoneNumberLength[_selectedCountryCode]!;
    final phoneNumberRaw = _phoneNumberController.text.trim();
    final phoneNumber =  phoneNumberRaw.replaceAll(RegExp(r'[()\s-]'), '');
    setState(() {
      _phoneNumber = _selectedCountryCode+phoneNumber;
    });
    if(phoneNumber.isEmpty) {
      return false;
    }
    return phoneNumber.length == phoneNumberLengthRequired;
  }

  // enable the verification button when all fields are valid
  void _updateButtonState() {
    _phoneNumberComplete();
    setState(() {
      _allValid = _phoneNumberComplete();
    });
  }

  void verifyPhoneNumber() async {
    developer.log("Phone number to submit: $_phoneNumber");
    setState(() {
      _isSaving = true;
    });
    final checkValid = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhoneVerificationScreen(
          phoneNumber: _phoneNumber,
        ),
      ),
    );
    if(checkValid != null){
      invalidNumberState();
    }
    setState(() {
      _isSaving = false;
    });
  }

  void invalidNumberState(){
    _navService.showPopup("The provided phone number is not valid.",
      color: getSnackbarColor(SnackbarType.error));
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
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
                    Text('Continue with phone', style: GlobalStyles.textStyles.heading2,),
                    Padding(
                      padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing16),
                      child: Text("We'll send you a code to help us verify your account.", style: GlobalStyles.textStyles.body2,)
                    ),
                    // Phone number field
                    Padding(
                      padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Phone number', style: GlobalStyles.textStyles.body1.copyWith(color: GlobalStyles.globalTextSubtle)),
                          SizedBox(height: GlobalStyles.spacingStates.spacing4,),
                          Row (
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomDropdownWidget(
                                buttonHeight: 55,
                                onChanged:(value) {
                                   setState(() {
                                    _selectedCountryCode = value;
                                  });
                                  _updateButtonState();
                                }, 
                                dropdownItems: _countryCodes
                                  .map((String value) {
                                    return DropdownItems(
                                      value: value,
                                      label: value,
                                      enabledButton: true
                                    );
                                }).toList(),
                                initialValue: _selectedCountryCode,
                                buttonWidth: 100,
                              ),
                              SizedBox(width: GlobalStyles.spacingStates.spacing16,),
                              Expanded(
                                child: InputFieldWidget(
                                  controller: _phoneNumberController,
                                  keyboardType: TextInputType.phone,
                                  countryCode: _selectedCountryCode,
                                  showErrorText: false,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ),
                  ]
                )
              ),
              CustomButtonWidget.primary(
                text: 'Send verification code',
                onPressed: _isSaving ? null : _allValid ? verifyPhoneNumber : null,
                showIsSaving: _isSaving,
              ),
            ]
          )
        )
      ),
    );
  }
}
