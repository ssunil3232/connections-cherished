import 'package:connectionscherished/main.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/util/screen_util.dart';
import 'package:flutter/material.dart';

class NavigationService {
  // You can modify this method to pass arguments if applicable.
  Future<dynamic> navigateTo(String routeName, {arguments}) {
    return navigatorKey.currentState!
        .pushNamedAndRemoveUntil(routeName, (route) => false, arguments: arguments);
  }

  void showPopup(String message, {required Color color}) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: GlobalStyles.textStyles.caption2.copyWith(color: GlobalStyles.globalBgDefault),
          ),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: GlobalStyles.spacingStates.spacing20, vertical: GlobalStyles.spacingStates.spacing12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ScreenUtil.setSp(10.0)),
          ),
        ),
      );
    }
  }
}

enum SnackbarType { success, alert, error }

Color getSnackbarColor(SnackbarType type) {
  switch (type) {
    case SnackbarType.success:
      return GlobalStyles.globalSuccessText;
    case SnackbarType.alert:
      return GlobalStyles.warning.warning500;
    case SnackbarType.error:
      return GlobalStyles.globalErrorText;
    }
}
