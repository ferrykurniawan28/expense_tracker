import 'package:expense_tracker/controllers/balance_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseController extends GetxController {
  var expense = 0.obs;
  final _balanceController = Get.find<BalanceController>();
  TextEditingController titleController = TextEditingController();
  TextEditingController expenseController = TextEditingController();

  void addExpense(int amount) {
    expense.value += amount;
    _balanceController.addExpense(amount);
  }

  @override
  void dispose() {
    titleController.dispose();
    expenseController.dispose();
    super.dispose();
  }
}
