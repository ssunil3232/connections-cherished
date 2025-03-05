import 'package:connectionscherished/home.dart';
import 'package:connectionscherished/journals/journal_landing.dart';
import 'package:connectionscherished/models/user_model.dart';
import 'package:connectionscherished/user/user_profile.dart';
import 'package:connectionscherished/widgets/navigation/bottom_nav_bar_widget.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  UserModel? user = UserModel();
  int _selectedIndex = 0;
  
  @override
  void initState() {
    super.initState();
  }

  _updateNavigation(int index) async {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => JournalLanding()),
      );
    }
    else if (index == 1) {
        
    } 
    else if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserProfileScreen()),
        );
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
        body: HomePage(),
        bottomNavigationBar: BottomNavBarWidget(
          selectedIndex: _selectedIndex,
          onTabSelected: _updateNavigation,
        ),
    );
  }
}
