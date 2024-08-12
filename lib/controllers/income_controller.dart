import 'dart:async';

import 'package:expense_tracker/controllers/balance_controller.dart';
import 'package:expense_tracker/controllers/database_controller.dart';
import 'package:get/get.dart';

class IncomeController extends GetxController {
  var income = 0.obs;
  var incomeforDay = 0.obs;
  var incomeforWeek = 0.obs;
  var incomeforMonth = 0.obs;

  DateTime startOfWeek = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day - DateTime.now().weekday + 1);
  late DateTime endOfWeek;
  final DateTime today = DateTime.now();

  final _balanceController = Get.put(BalanceController());
  final _dbC = Get.put(DatabaseController());

  @override
  void onInit() async {
    endOfWeek = startOfWeek.add(const Duration(days: 6));
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      income.value = await _dbC.getIncome();
      incomeforDay.value = await _dbC.getIncomeforDay(DateTime.now());
      incomeforWeek.value = await _dbC.getIncomeforWeek(startOfWeek, endOfWeek);
      incomeforMonth.value = await _dbC.getIncomeforMonth(today);
    });
    income.value = await _dbC.getIncome();
    incomeforDay.value = await _dbC.getIncomeforDay(DateTime.now());
    incomeforWeek.value = await _dbC.getIncomeforWeek(startOfWeek, endOfWeek);
    incomeforMonth.value = await _dbC.getIncomeforMonth(today);
    super.onInit();
  }

  void addIncome(int amount, DateTime date) {
    income.value += amount;
    _balanceController.addIncome(amount, date);
    _dbC.updateIncome(income.value);
  }
}
