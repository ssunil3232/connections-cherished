import 'package:connectionscherished/home.dart';
import 'package:connectionscherished/insights/insight_landing.dart';
import 'package:connectionscherished/journals/journal_landing.dart';
import 'package:connectionscherished/models/user_model.dart';
import 'package:connectionscherished/services/auth_service.dart';
import 'package:connectionscherished/user/user_profile.dart';
import 'package:connectionscherished/widgets/navigation/bottom_nav_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with RouteAware {
  int _selectedIndex = 0;
  final _accountService = GetIt.I.get<AuthService>();
  UserModel ? user;
  
  @override
  void initState() {
    super.initState();
    loadUser();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  loadUser() async {
    user = await _accountService.getLoggedInUser();
    setState(() {});
  }

  _updateNavigation(int index) async {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => JournalLanding()),
      );
    }
    else if (index == 1) {
        // Insights Page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InsightLanding()),
      );
    } 
    else if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserProfileScreen(
            user: user,
          )),
        ).then((_) {
          loadUser();
        });
    } 
    else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: HomePage(user: user,),
        bottomNavigationBar: BottomNavBarWidget(
          selectedIndex: _selectedIndex,
          onTabSelected: _updateNavigation,
        ),
    );
  }
}
