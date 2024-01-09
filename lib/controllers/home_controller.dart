import 'package:expense_tracker/controllers/deposit_cotroller.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;
  // final depositC = Get.put(DepositController());

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
