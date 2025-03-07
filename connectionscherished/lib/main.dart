import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectionscherished/auth/create_account_screen.dart';
import 'package:connectionscherished/dashboard.dart';
import 'package:connectionscherished/home.dart';
import 'package:connectionscherished/journals/journal_landing.dart';
import 'package:connectionscherished/routes.dart';
import 'package:connectionscherished/services/auth_service.dart';
import 'package:connectionscherished/services/friend_service.dart';
import 'package:connectionscherished/services/routing_service.dart';
import 'package:connectionscherished/services/user_service.dart';
import 'package:connectionscherished/services/util_service.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/user/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;

//For Navigation without context;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void setupLocator(FirebaseApp firebaseApp) {
  GetIt.I.registerLazySingleton(() => FirebaseFirestore.instance);
  GetIt.I.registerLazySingleton(() => AuthService());
  GetIt.I.registerLazySingleton(() => NavigationService());
  GetIt.I.registerLazySingleton(() => UserService());
  GetIt.I.registerLazySingleton(() => UtilService());
  GetIt.I.registerLazySingleton(() => FriendService());
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator(firebaseApp);
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // connectionsFuture = MongoDB.getDocuments();
    // _getConnections();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Screen is resumed - refresh connections data
      // _getConnections();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connections Cherished',
      navigatorKey: navigatorKey,
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: GlobalStyles.primaryText),
        useMaterial3: true,
        iconTheme: const IconThemeData(color: GlobalStyles.primaryText,
          weight: 400,
          opticalSize: 24),
        scaffoldBackgroundColor: GlobalStyles.defaultBg,
      ),
      initialRoute: Routes.splash,
      routes: {
        Routes.splash: (context) => const SplashScreen(),
        Routes.authOptions: (context) => const AuthOptionsScreen(), 
        Routes.home: (context) => HomePage(),
        Routes.dashboard: (context) => const DashboardScreen(),
        Routes.emailOption: (context) => const EmailLoginScreen(),
        Routes.phoneOption: (context) => const PhoneLoginScreen(),
        Routes.createAccount: (context) => const CreateAccountScreen(),
        Routes.userProfile: (context) =>  UserProfileScreen(),
        Routes.journalLanding: (context) => const JournalLanding(),
      },
    );
  }
}