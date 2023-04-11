import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatoryKey = GlobalKey<NavigatorState>();

  Future<void>? navigateTo(String routeName) {
    return navigatoryKey.currentState?.pushNamed(routeName);
  }

  Future<void>? navigateToWithArgs(String routeName, String args) {
    return navigatoryKey.currentState?.pushNamed(routeName, arguments: args);
  }

  Future<void> openDialog({required Widget content}) async {
    showDialog(context: navigatoryKey.currentContext!, builder: (_) => content);
  }

  Future<void> showSnackBar({required String message}) async {
    ScaffoldMessenger.of(navigatoryKey.currentContext!)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
