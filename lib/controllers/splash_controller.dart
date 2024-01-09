import 'package:expense_tracker/controllers/auth_controller.dart';
import 'package:expense_tracker/routes/routes_name.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final _auth = Get.find<AuthController>();
  RxBool isLoggedIn = false.obs;

  @override
  void onReady() {
    isLoggedIn.value = _auth.isLoggedIn.value;
    print(isLoggedIn.value);
    super.onReady();
  }

  void checkLogin() {
    if (!isLoggedIn.value) {
      Get.offAllNamed(RouteName.home);
    } else {
      Get.offAllNamed(RouteName.login);
    }
  }
}
