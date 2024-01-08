import 'package:expense_tracker/controllers/auth_controller.dart';
import 'package:expense_tracker/controllers/signup_controller.dart';
import 'package:get/get.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpController());
    Get.put(AuthController());
  }
}
