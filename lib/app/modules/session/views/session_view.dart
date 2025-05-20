import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/session_controller.dart';

class SessionView extends GetView<SessionController> {
  const SessionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SessionView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SessionView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
