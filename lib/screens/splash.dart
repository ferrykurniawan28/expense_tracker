import 'package:expense_tracker/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Splash extends GetView<SplashController> {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SplashController());
    Future.delayed(
      const Duration(seconds: 2),
      () {
        // Get.offNamed(RouteName.login);
        controller.checkLogin();
      },
    );
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 64, 58, 122)),
        child: const Center(
          child: Text(
            'Finance Tracker',
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
