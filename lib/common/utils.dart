
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void showSnackBar(BuildContext context, String text) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger != null) {
    messenger.showSnackBar(
      SnackBar(content: Text(text)),
    );
  } else {
    debugPrint("Snackbar skipped (no ScaffoldMessenger): $text");
  }
}