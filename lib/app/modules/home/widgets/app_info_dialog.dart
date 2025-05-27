import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppInfoDialog extends StatelessWidget {
  const AppInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('what_is_ulala'.tr),
      content: Text('what_is_ulala_desc'.tr),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('close'.tr),
        ),
      ],
    );
  }
}
