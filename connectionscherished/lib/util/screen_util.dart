import 'package:flutter/material.dart';
class ScreenUtil {
  static double _screenWidth = 0;
  static double _screenHeight = 0;
  static double _scaleWidth = 0;
  static double _scaleHeight = 0;
  static const double _designWidth = 375;
  static const double _designHeight = 812;

  static const double _small2Medium = 410;
  static const double _medium2Large = 660;

  /// e.g. iPhone 16, 16 Pro
  static bool _isSmallScreen = false;
  /// e.g. iPhone 16 Pro Max
  static bool _isMediumScreen = false;
  /// e.g. iPad
  static bool _isLargeScreen = false;

  static void init(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _scaleWidth = _screenWidth / _designWidth;
    _scaleHeight = _screenHeight / _designHeight;
    _isSmallScreen = _screenWidth <= _small2Medium;
    _isMediumScreen = _screenWidth > _small2Medium && _screenWidth <= _medium2Large;
    _isLargeScreen = _screenWidth > _medium2Large;
  }

  bool get isSmallScreen => _isSmallScreen;
  bool get isMediumScreen => _isMediumScreen;
  bool get isLargeScreen => _isLargeScreen;


  /// Scales the width of the UI element based on the screen width.
  static double setWidth(double width) {
    return width * _scaleWidth;
  }

  /// Scales the height of the UI element based on the screen height.
  static double setHeight(double height) {
    return height * _scaleHeight;
  }

  /// Scales the font size based on the screen width.
  static double setSp(double fontSize) {
    return fontSize * _scaleWidth;
  }
}