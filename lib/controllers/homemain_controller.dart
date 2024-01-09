import 'package:expense_tracker/controllers/balance_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeMainController extends GetxController {
  TextEditingController balanceTargetController = TextEditingController();
  final form = GlobalKey<FormState>();

  final _balance = Get.put(BalanceController());

  @override
  void onInit() {
    // _balance.balance
    super.onInit();
  }

  void editTargetBalance() {
    final isValid = form.currentState!.validate();
    if (!isValid) {
      return;
    }
    int target = int.parse(balanceTargetController.text);
    _balance.editTargetBalance(target);
    balanceTargetController.clear();
    Get.back();
    Get.snackbar('Success', 'Target balance updated');
  }

  void showModal() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: form,
          child: Column(
            children: [
              TextFormField(
                controller: balanceTargetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Target Balance',
                  prefix: Text('RP '),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter target balance';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: editTargetBalance,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }
}
