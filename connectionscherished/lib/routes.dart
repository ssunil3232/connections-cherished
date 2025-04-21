export 'auth/splash_screen.dart';
export 'auth/auth_options_screen.dart';

// email account input screens
export 'auth/email_login/email_login_option_screen.dart';

// email sign in/sign up screens
export 'auth/email_login/sign_in_screen.dart';
export 'auth/email_login/sign_up_screen.dart';

class Routes {
  static const String splash = '/';
  static const String home = '/home';
  static const String authOptions = '/auth_options';
  static const String emailOption = '/email_option';
  static const String emailVerification = '/email_verification';
  static const String phoneOption = '/phone_option';
  static const String createAccount = '/create_account';
  static const String userProfile = '/userProfile';
  static const String dashboard = '/dashboard';
  static const String journalLanding = '/journalLanding';
  static const String journalEntry = '/journalEntry';
  static const String journalEntryDetails = '/journalEntryDetails';
}
