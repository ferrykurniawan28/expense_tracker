import 'package:expense_tracker/controllers/auth_controller.dart';
import 'package:expense_tracker/controllers/deposit_cotroller.dart';
import 'package:expense_tracker/controllers/login_controller.dart';
import 'package:get/get.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
    Get.put(AuthController());
    Get.put(DepositController());
    // Get.put(BalanceController());
  }
}
