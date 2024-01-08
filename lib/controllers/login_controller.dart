import 'package:expense_tracker/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final form = GlobalKey<FormState>();

  final _authController = Get.find<AuthController>();

  void login() {
    final isValid = form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _authController.login(
      emailController.text,
      passwordController.text,
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
