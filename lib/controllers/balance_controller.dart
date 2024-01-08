import 'package:expense_tracker/controllers/database_controller.dart';
import 'package:expense_tracker/models/event.dart';
import 'package:get/get.dart';

class BalanceController extends GetxController {
  var balance = 0.obs;
  var targetBalance = 0.obs;

  final _dbC = Get.put(DatabaseController());

  @override
  void onInit() async {
    balance.value = await _dbC.getBalance();
    targetBalance.value = await _dbC.getTargetBalance();
    super.onInit();
  }

  void addIncome(int amount, DateTime date) {
    balance.value += amount;
    _dbC.updateBalance(balance.value);
    final Event data = Event(
      'Income',
      amount,
      date,
      true,
    );
    _dbC.addEvent(data);
  }

  void addExpense(int amount) {
    balance.value -= amount;
    _dbC.updateBalance(balance.value);
  }

  void editTargetBalance(int amount) {
    targetBalance.value = amount;
    _dbC.updateTargetBalance(amount);
  }
}
