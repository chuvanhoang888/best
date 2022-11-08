import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget web;
  const Responsive({super.key, required this.mobile, required this.tablet, required this.web});

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768.0;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 768.0 &&
      MediaQuery.of(context).size.width < 1200.0;

  static bool isWeb(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200.0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 768) {
      return mobile;
    }
    if (width >= 768.0 && width < 1200.0) {
      return tablet;
    }
    return web;
  }
}