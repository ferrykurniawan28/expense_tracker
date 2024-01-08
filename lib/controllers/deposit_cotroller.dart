import 'package:expense_tracker/controllers/balance_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DepositController extends GetxController {
  TextEditingController depositController = TextEditingController();
  final form = GlobalKey<FormState>();
  final _balance = Get.put(BalanceController());

  void addDeposit(DateTime date) {
    final isValid = form.currentState!.validate();
    if (!isValid) {
      return;
    }
    int balance = int.parse(depositController.text);
    _balance.addIncome(balance, date);
    depositController.clear();
    Get.snackbar('Success', 'Deposit success');
    Get.back();
  }

  @override
  void dispose() {
    depositController.dispose();
    super.dispose();
  }
}
