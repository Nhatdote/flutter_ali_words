import 'package:flutter/material.dart';

class Toast {
  
  static ScaffoldMessengerState? _scaffoldMessenger;

  static void initialize(BuildContext context) {
    _scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  static void show(dynamic message, {
    SnackBarAction? action, 
    Color color = const Color(0xFF323232),
    bool hidePrevSnackbar = true
  }) {

    if (hidePrevSnackbar) {
      _scaffoldMessenger?.hideCurrentSnackBar();
    }

    final snackBar = SnackBar(
      content: message.runtimeType == String ? Text(message) : message,
      action: action,
      backgroundColor: color,
      showCloseIcon: true,
      closeIconColor: Colors.white70,
    );

    _scaffoldMessenger?.showSnackBar(snackBar);
  }
  
}