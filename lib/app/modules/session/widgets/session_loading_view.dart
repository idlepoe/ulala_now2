import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SessionLoadingView extends StatelessWidget {
  const SessionLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/icon-removebg.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 32),

            Text(
              'checking_session_state'.tr,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            const CircularProgressIndicator(strokeCap: StrokeCap.round),
          ],
        ),
      ),
    );
  }
}
