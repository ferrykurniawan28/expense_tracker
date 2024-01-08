import 'package:expense_tracker/controllers/forget_controller.dart';
import 'package:get/get.dart';

class ForgetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgetController());
  }
}
