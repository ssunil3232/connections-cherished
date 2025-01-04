String phoneNumberMask(String phoneNumber){
    final countryCodes = ['+1', '+86', '+966'];
    String maskedPhoneNumber = phoneNumber;
    for (String code in countryCodes) {
      if (phoneNumber.startsWith(code)) {
        maskedPhoneNumber = phoneNumber.replaceFirst(code, '');
        int length = maskedPhoneNumber.length;
        if (length > 4) {
          String lastFour = maskedPhoneNumber.substring(length - 4);
          String maskedPart = 'X' * (length - 4);
          maskedPhoneNumber = maskedPart + lastFour;
        }
      }
    }
    return maskedPhoneNumber;
}