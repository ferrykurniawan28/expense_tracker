import 'package:expense_tracker/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetController extends GetxController {
  TextEditingController emailController = TextEditingController();
  final form = GlobalKey<FormState>();

  final _authController = Get.find<AuthController>();

  void forget() {
    final isValid = form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _authController.forgetPassword(emailController.text);
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
