import 'package:expense_tracker/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final form = GlobalKey<FormState>();
  final _authController = Get.find<AuthController>();

  void signup() {
    final isValid = form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _authController.register(
      emailController.text,
      passwordController.text,
      nameController.text,
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    nameController.dispose();
    super.dispose();
  }
}
