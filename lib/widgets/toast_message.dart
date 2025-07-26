import 'package:ahes_maps/constants/colors.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';

class ToastMessage {
  static void showSuccess(BuildContext context, String titleText) {
    CherryToast.success(
      title: Text(
        titleText,
        style: const TextStyle(color: Colors.black),
      ),
      animationType: AnimationType.fromTop,
      animationDuration: const Duration(milliseconds: 1500),
      toastDuration: const Duration(milliseconds: 3000),
    ).show(context);
  }

  static void showError(BuildContext context, String titleText) {
    CherryToast.error(
      title: Text(
        titleText,
        style: const TextStyle(color: Colors.black),
      ),
      animationType: AnimationType.fromTop,
      animationDuration: const Duration(milliseconds: 1500),
      toastDuration: const Duration(milliseconds: 3000),
    ).show(context);
  }

  static void showWarning(BuildContext context, String titleText) {
    CherryToast.warning(
      title: Text(
        titleText,
        style: TextStyle(color: hitam),
      ),
      animationType: AnimationType.fromTop,
      animationDuration: const Duration(milliseconds: 1500),
      toastDuration: const Duration(milliseconds: 3000),
    ).show(context);
  }
}
