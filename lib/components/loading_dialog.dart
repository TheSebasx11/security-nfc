import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return const Center(
        child: SizedBox(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    },
  );
}
