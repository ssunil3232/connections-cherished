import 'package:connectionscherished/auth/create_account_screen.dart';
import 'package:connectionscherished/dashboard.dart';
import 'package:connectionscherished/home.dart';
import 'package:connectionscherished/journals/journal_landing.dart';
import 'package:connectionscherished/routes.dart';
import 'package:connectionscherished/services/auth_service.dart';
import 'package:connectionscherished/services/friend_service.dart';
import 'package:connectionscherished/services/providers/profile_img_provider.dart';
import 'package:connectionscherished/services/routing_service.dart';
import 'package:connectionscherished/services/user_service.dart';
import 'package:connectionscherished/services/util_service.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/user/user_profile.dart';
import 'package:connectionscherished/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;

//For Navigation without context;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void setupLocator(Supabase supabaseApp) {
  GetIt.I.registerLazySingleton(() => AuthService());
  GetIt.I.registerLazySingleton(() => NavigationService());
  GetIt.I.registerLazySingleton(() => UserService());
  GetIt.I.registerLazySingleton(() => UtilService());
  GetIt.I.registerLazySingleton(() => FriendService());
  GetIt.I.registerLazySingleton<ProfileImgProvider>(()=>ProfileImgProvider());
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final supabaseApp = await Supabase.initialize(
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR2c29kYW9qY3Bka2d2d2tibWNpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM2MjEyMjgsImV4cCI6MjA1OTE5NzIyOH0.zUS-Ij-nd6lMNDSA1KZAIJjc8r9K8RUABMsCWczQGOs",
    url: "https://tvsodaojcpdkgvwkbmci.supabase.co"
  );
  setupLocator(supabaseApp);
  tz.initializeTimeZones();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ProfileImgProvider(),
      child: MyApp()
    )
  );
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
    return LayoutBuilder(
      builder: (context, constraints) {
        ScreenUtil.init(context);
        MaterialSymbolsBase.setRoundedVariationDefaults(
          size: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing24),
          fill: 0.0,
          weight: 400,
          grade: 0.0,
          opticalSize: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing24),
          color: GlobalStyles.primaryText,
        );
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => GetIt.I<ProfileImgProvider>()),
          ],
          builder: (context, child) => MaterialApp(
            title: 'Connections Cherished',
            navigatorKey: navigatorKey,
            navigatorObservers: [routeObserver],
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: GlobalStyles.primaryText),
              useMaterial3: true,
              iconTheme: IconThemeData(color: GlobalStyles.primaryText,
                weight: 400,
                opticalSize: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing24)),
              scaffoldBackgroundColor: GlobalStyles.defaultBg,
            ),
            initialRoute: Routes.splash,
            routes: {
              Routes.splash: (context) => const SplashScreen(),
              Routes.authOptions: (context) => const AuthOptionsScreen(), 
              Routes.home: (context) => HomePage(),
              Routes.dashboard: (context) => const DashboardScreen(),
              Routes.emailOption: (context) => const EmailLoginScreen(),
              Routes.createAccount: (context) => const CreateAccountScreen(),
              Routes.userProfile: (context) =>  UserProfileScreen(),
              Routes.journalLanding: (context) => const JournalLanding(),
            },
          ),
        );
      }
    );
  }
}