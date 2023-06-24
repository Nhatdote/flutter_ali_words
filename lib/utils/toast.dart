import 'package:flutter/material.dart';

class Toast {

  static const String toastSuccess = 'success';
  static const String toastError = 'error';
  
  static ScaffoldMessengerState? _scaffoldMessenger;

  static void initialize(BuildContext context) {
    _scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  static void show(dynamic message, {
    SnackBarAction? action, 
    Color color = const Color(0xFF323232),
    bool hidePrevSnackbar = true,
    String? type,
  }) {

    if (hidePrevSnackbar) {
      _scaffoldMessenger?.hideCurrentSnackBar();
    }

    var snackBarColor = color;
    if (type != null && [toastSuccess, toastError].contains(type)) {
      snackBarColor = type == toastSuccess ? Colors.green : Colors.redAccent;
    }

    final snackBar = SnackBar(
      content: message.runtimeType == String ? Text(message) : message,
      action: action,
      backgroundColor: snackBarColor,
      showCloseIcon: true,
      closeIconColor: Colors.white70,
    );

    _scaffoldMessenger?.showSnackBar(snackBar);
  }
  
}