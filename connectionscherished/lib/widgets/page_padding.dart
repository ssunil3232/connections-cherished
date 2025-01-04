import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PagePadding extends StatelessWidget {
  final Widget child;
  double bottomPadding;

  PagePadding({super.key, required this.child, this.bottomPadding = 0});

  @override
  Widget build(BuildContext context) {
    return 
    SafeArea(
      minimum: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: bottomPadding
      ),
      top: false,
      bottom: false,
      left: true,
      right: true,
      child: child
    );
  }
}