import 'package:connectionscherished/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class BottomNavBarWidget extends StatefulWidget {
  int selectedIndex = 0;
  final Function(int) onTabSelected;
  BottomNavBarWidget({this.selectedIndex = 0, super.key, required this.onTabSelected});

  @override
  _BottomNavBarWidgetState createState() =>
      _BottomNavBarWidgetState();
}

class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
    data: ThemeData(
      splashColor: Colors.transparent,
      highlightColor: const Color.fromARGB(0, 170, 15, 15)
    ),
    child: _buildNavigationBar());
  }

  Widget _buildNavigationBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing20)),
                topRight: Radius.circular(GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing20)),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: GlobalStyles.bottomNavBg,
                ), 
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  useLegacyColorScheme: false,
                  enableFeedback: false,
                  selectedFontSize: 0,
                  unselectedFontSize:0,
                  iconSize: 0,
                  // selectedFontSize: GlobalStyles.textStyles.textCaption3.fontSize!,
                  // unselectedFontSize: GlobalStyles.textStyles.textCaption3.fontSize!,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  unselectedLabelStyle: GlobalStyles.textStyles.textCaption3,
                  selectedLabelStyle: GlobalStyles.textStyles.textCaption3,
                  currentIndex: widget.selectedIndex,
                  backgroundColor: GlobalStyles.bottomNavBg,
                  onTap: (int index) {
                    setState(() {
                      widget.selectedIndex = index;
                      widget.onTabSelected(widget.selectedIndex);
                    });
                  },
                  items: <BottomNavigationBarItem>[
                    // BottomNavigationBarItem(
                    //   icon: _buildIcon(icon: 'assets/icons/journal_logo.svg', isSelected: false),
                    //   // activeIcon: _buildIcon(icon: 'assets/icons/journal_logo.svg', isSelected: true),
                    //   label: 'Home',   
                    // ),
                    BottomNavigationBarItem(
                      icon: _buildIcon(icon: 'assets/icons/journal_logo.svg', isSelected: false),
                      // activeIcon: _buildIcon(icon: 'assets/icons/journal_logo.svg', isSelected: true),
                      label: 'Journal',   
                    ),
                    BottomNavigationBarItem(
                      icon: _buildIcon(icon: 'assets/icons/insights_logo.svg', isSelected: false),
                      // activeIcon: _buildIcon(icon: Symbols.voice_chat_rounded, isSelected: true),
                      label: 'Insights',   
                    ),
                    BottomNavigationBarItem(
                      icon: _buildIcon(icon: 'assets/icons/profile_logo.svg', isSelected: false),
                      // activeIcon: _buildIcon(icon: Symbols.extension_rounded, isSelected: true),
                      label: 'Profile',   
                    ),
                  ],
                )
              ),
            )
          ]
        );
      }
    );
  }

  Widget _buildIcon({
    required String icon,
    required bool isSelected,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(top: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing8), bottom: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing4)), 
          child: SvgPicture.asset(
            icon, 
            width: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing40, useWidth: true), 
            height: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing40)
          ),
        ),
      ],
    );
  }
}
