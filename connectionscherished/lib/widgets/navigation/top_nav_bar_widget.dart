import 'package:connectionscherished/routes.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ignore: must_be_immutable
class TopNavBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Widget header;
  final Color? bgColor;
  final List<Widget>? actions;
  final Widget? leading;
  double ? height;
  final bool showBackButton;
  final Future<void> Function()? backAction;
  bool showBorder;
  TopNavBarWidget(
      {super.key, required this.header, this.actions, this.leading, required this.showBackButton, this.showBorder = true, this.backAction, this.bgColor, this.height});

  final SupabaseClient _authService = Supabase.instance.client;

  void logout() async {
    await _authService.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: header,
        centerTitle: true,
        scrolledUnderElevation: 0,
        toolbarHeight: 100.0,
        leading: showBackButton ? Padding(
          padding: EdgeInsets.only(left: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing16, useWidth: true)),
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
        backgroundColor: bgColor ?? GlobalStyles.topNavBg,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: showBorder ? GlobalStyles.defaultTextBg: Colors.transparent,
            height: 1,
          ),
        ),
        elevation: 0,
        actions: actions?.map((action) {
                return Padding(
                  padding: EdgeInsets.only(right: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing8, useWidth: true), bottom: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing4)),
                  child: action,
                );
              }).toList(),
      
    );
    
  }
  @override
  Size get preferredSize => Size.fromHeight(height != null ? (height!-40) : 100.0);
}