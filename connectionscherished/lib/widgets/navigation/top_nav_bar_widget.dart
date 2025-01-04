import 'package:connectionscherished/routes.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

// ignore: must_be_immutable
class TopNavBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Widget header;
  final Color? bgColor;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final Future<void> Function()? backAction;
  bool showBorder;
  TopNavBarWidget(
      {super.key, required this.header, this.actions, this.leading, required this.showBackButton, this.showBorder = true, this.backAction, this.bgColor});

  final _authService = FirebaseAuth.instance;

  void logout() async {
    await _authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: header,
        centerTitle: true,
        scrolledUnderElevation: 0,
        toolbarHeight: 56.0,
        leading: showBackButton ? Padding(
          padding: EdgeInsets.only(left: GlobalStyles.spacingStates.spacing16),
          child: leading ?? IconButton(
                  icon: VariedIcon.varied(
                    Symbols.arrow_back_ios_rounded,
                  ),
                  onPressed: () async {
                    if (Navigator.canPop(context)) {
                      if(backAction!=null){
                        await backAction!();
                      }
                      Navigator.pop(context);
                    } else {
                      logout();
                      Navigator.pushNamedAndRemoveUntil(context, Routes.authOptions, (route) => false);
                    }
                  },
                )
        ): null,
        backgroundColor: bgColor ?? GlobalStyles.globalBgDefault,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.5),
          child: Container(
            color: showBorder ? GlobalStyles.cardBorderDefault: Colors.transparent,
            height: 1.5,
          ),
        ),
        elevation: 0,
        actions: actions?.map((action) {
                return Padding(
                  padding: EdgeInsets.only(right: GlobalStyles.spacingStates.spacing8, bottom: GlobalStyles.spacingStates.spacing4),
                  child: action,
                );
              }).toList(),
      
    );
    
  }
  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}