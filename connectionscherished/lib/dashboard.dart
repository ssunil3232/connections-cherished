import 'package:connectionscherished/home.dart';
import 'package:connectionscherished/models/user_model.dart';
import 'package:connectionscherished/widgets/navigation/bottom_nav_bar_widget.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // final OnboardingStatusService _onboardingService = GetIt.I<OnboardingStatusService>();
  UserModel? user = UserModel();
  int _selectedIndex = 0;
  late final List<Widget> fragments;
  
  @override
  void initState() {
    super.initState();
    fragments = [
      // HomePage(),
      Container(),//Journal,
      Container(),//Insights,
      Container()//Profile,
    ];
  }

  _updateNavigation(int index) async {
    // if (index == 0) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => HomePage()),
    //   );
    // }
    // else if (index == 3) {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => ChatBotView()),
    //     );
    // } 
    // else {
      setState(() {
        _selectedIndex = index;
      });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0 ? HomePage() : _buildBottomFragment(_selectedIndex - 1),
      bottomNavigationBar: BottomNavBarWidget(
        selectedIndex: _selectedIndex, 
        onTabSelected: _updateNavigation,
      ),
    );
  }

  Widget _buildBottomFragment(int index) {
    return fragments[index];
  }
}
