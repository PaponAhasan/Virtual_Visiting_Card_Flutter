import 'package:flutter/material.dart';

void showMessage(context, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
  ));
}