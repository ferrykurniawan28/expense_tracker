import 'package:expense_tracker/controllers/balance_controller.dart';
import 'package:expense_tracker/controllers/expense%20controller.dart';
import 'package:expense_tracker/controllers/homemain_controller.dart';
import 'package:expense_tracker/controllers/income_controller.dart';
import 'package:expense_tracker/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

class HomeMain extends GetView<HomeMainController> {
  const HomeMain({super.key});

  @override
  Widget build(BuildContext context) {
    final balanceC = Get.put(BalanceController());
    final exC = Get.put(ExpenseController());
    final incomeC = Get.put(IncomeController());
    final homeC = Get.put(HomeMainController());
    return Scaffold(
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.edit),
            label: 'Edit Target Balance',
            onTap: () => controller.showModal(),
          ),
        ],
      ),
      body: ListView(
        children: [
          Card(
            color: const Color.fromARGB(255, 64, 58, 122),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const Text(
                      'Balance',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Obx(() => Text(
                          CurrencyFormat.convertToIdr(
                              balanceC.balance.value, 2),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
          Card(
            color: const Color.fromARGB(255, 64, 58, 122),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const Text(
                      'Target Balance',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Obx(
                      () => Text(
                        CurrencyFormat.convertToIdr(
                            balanceC.targetBalance.value, 2),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            color: const Color.fromARGB(255, 64, 58, 122),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const Text(
                      'Total Expense',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Obx(
                      () => Text(
                        CurrencyFormat.convertToIdr(exC.expense.value, 2),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Text(
                      'Expense this month',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Obx(
                      () => Text(
                        CurrencyFormat.convertToIdr(
                            exC.expenseforMonth.value, 2),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Text(
                      'Expense this week',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Obx(
                      () => Text(
                        CurrencyFormat.convertToIdr(
                            exC.expenseforWeek.value, 2),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Text(
                      'Expense this day',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Obx(
                      () => Text(
                        CurrencyFormat.convertToIdr(exC.expenseforDay.value, 2),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            color: Color.fromARGB(255, 64, 58, 122),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const Text(
                      'Total Income',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Obx(
                      () => Text(
                        CurrencyFormat.convertToIdr(incomeC.income.value, 2),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Text(
                      'Income this month',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Obx(
                      () => Text(
                        CurrencyFormat.convertToIdr(
                            incomeC.incomeforMonth.value, 2),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Text(
                      'Income this week',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Obx(
                      () => Text(
                        CurrencyFormat.convertToIdr(
                            incomeC.incomeforWeek.value, 2),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Text(
                      'Income this day',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Obx(
                      () => Text(
                        CurrencyFormat.convertToIdr(
                            incomeC.incomeforDay.value, 2),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
