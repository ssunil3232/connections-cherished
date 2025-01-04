import 'package:connectionscherished/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

// ignore: must_be_immutable
class BottomNavBarWidget extends StatefulWidget {
  int selectedIndex = 0;
  final Function(int) onTabSelected;
  final List<GlobalKey> tipKeys;
  BottomNavBarWidget({this.selectedIndex = 0, super.key, required this.onTabSelected, required this.tipKeys});

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
      highlightColor: Colors.transparent
    ),
    child: _buildNavigationBar());
  }

  Widget _buildNavigationBar() {
    return 
      LayoutBuilder(
        builder: (context, constraints) {
          double totalWidth = constraints.maxWidth;
          double tabWidth = totalWidth/4;
          double leftOffset = widget.selectedIndex * tabWidth;

          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: GlobalStyles.globalBgDefault,
                  border: Border(
                    top: BorderSide(color: GlobalStyles.cardBorderDefault, width: 1.0),
                  ),
                ), 
                child:
                  BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    useLegacyColorScheme: false,
                    enableFeedback: false,
                    selectedFontSize: GlobalStyles.textStyles.boldBody2.fontSize!,
                    unselectedFontSize: GlobalStyles.textStyles.boldBody2.fontSize!,
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    unselectedLabelStyle: GlobalStyles.textStyles.boldBody2.copyWith(
                                  color: GlobalStyles.menuDefault
                                ),
                    selectedLabelStyle: GlobalStyles.textStyles.boldBody2.copyWith(
                                  color: GlobalStyles.menuActive
                                ),
                    currentIndex: widget.selectedIndex,
                    backgroundColor: GlobalStyles.globalBgDefault,
                    onTap: (int index) {
                      setState(() {
                        widget.selectedIndex = index;
                        widget.onTabSelected(index);
                      });
                    },
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: _buildIcon(icon: Symbols.home_filled_rounded, isSelected: false),
                        activeIcon: _buildIcon(icon: Symbols.home_filled_rounded, isSelected: true),
                        label: 'Home',   
                      ),
                      BottomNavigationBarItem(
                        icon: _buildIcon(icon: Symbols.voice_chat_rounded, isSelected: false),
                        activeIcon: _buildIcon(icon: Symbols.voice_chat_rounded, isSelected: true),
                        label: 'Kid Pal',   
                      ),
                      BottomNavigationBarItem(
                        icon: _buildIcon(icon: Symbols.extension_rounded, isSelected: false),
                        activeIcon: _buildIcon(icon: Symbols.extension_rounded, isSelected: true),
                        label: 'Evaluation',   
                      ),
                      BottomNavigationBarItem(
                        icon: _buildIcon(icon: Symbols.chat_bubble_rounded, isSelected: false),
                        activeIcon: _buildIcon(icon: Symbols.chat_bubble_rounded, isSelected: true),
                        label: 'AI Advisor',   
                      ),
                    ],
                  )
                ),
                Positioned(
                  top: 0,
                  left: leftOffset,
                  child: Container(
                    width: tabWidth,
                    height: 2.0,
                    color: GlobalStyles.menuActive,
                  ),
                ),
    
        ]);
      }
    );
  }

  Widget _buildIcon({
    required IconData icon,
    required bool isSelected,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing4, bottom: 0), 
          child: VariedIcon.varied(icon, 
            fill: isSelected ? 1: 0,
            color: isSelected ? GlobalStyles.menuActive : GlobalStyles.globalIconDefault
          ),
        ),
      ],
    );
  }
}
