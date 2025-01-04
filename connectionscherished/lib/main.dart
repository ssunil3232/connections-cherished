import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectionscherished/home.dart';
import 'package:connectionscherished/routes.dart';
import 'package:connectionscherished/services/auth_service.dart';
import 'package:connectionscherished/services/friend_service.dart';
import 'package:connectionscherished/services/routing_service.dart';
import 'package:connectionscherished/services/user_service.dart';
import 'package:connectionscherished/user/user_profile.dart';
import 'package:connectionscherished/user/user_settings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'firebase_options.dart';


//For Navigation without context;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void setupLocator(FirebaseApp firebaseApp) {
  GetIt.I.registerLazySingleton(() => FirebaseFirestore.instance);
  GetIt.I.registerLazySingleton(() => AuthService());
  GetIt.I.registerLazySingleton(() => NavigationService());
  GetIt.I.registerLazySingleton(() => UserService());
  GetIt.I.registerLazySingleton(() => FriendService());
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator(firebaseApp);
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        iconTheme: const IconThemeData(color: Color(0xFF64748b),
          weight: 400,
          opticalSize: 24),
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: Routes.splash,
      routes: {
        Routes.splash: (context) => const SplashScreen(),
        Routes.authOptions: (context) => const AuthOptionsScreen(), 
        Routes.home: (context) => const HomePage(),
        Routes.emailOption: (context) => const EmailLoginScreen(),
        Routes.phoneOption: (context) => const PhoneLoginScreen(),
        Routes.userSettings: (context) => const UserSettingsScreen(),
        Routes.userProfile: (context) => const UserProfileScreen(),
      },
    );
  }
}