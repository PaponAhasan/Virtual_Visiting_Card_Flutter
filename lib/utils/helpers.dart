import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void showMessage(context, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
  ));
}

void showDefaultLoading() {
  EasyLoading.show(status: 'Loading...');
}

void showSuccess() {
  EasyLoading.showSuccess('Loaded successfully!');
  EasyLoading.dismiss();
}