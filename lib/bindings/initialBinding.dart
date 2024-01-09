import 'package:expense_tracker/controllers/auth_controller.dart';
import 'package:expense_tracker/controllers/splash_controller.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
    Get.put(AuthController());
  }
}
