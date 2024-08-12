import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:expense_tracker/controllers/auth_controller.dart';
import 'package:expense_tracker/controllers/home_controller.dart';
import 'package:expense_tracker/routes/routes_name.dart';
import 'package:expense_tracker/screens/homemain.dart';
import 'package:expense_tracker/screens/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends GetView<HomeController> {
  Home({super.key});
  final homeC = Get.put(HomeController());
  // final balanceC = Get.put(BalanceController());
  // final expenseC = Get.put(ExpenseController());
  // final incomeC = Get.put(IncomeController());

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 64, 58, 122),
        title: Obx(() {
          return (controller.currentIndex.value == 0)
              ? const Text(
                  'Home',
                  style: TextStyle(color: Colors.white),
                )
              : const Text(
                  'Expense',
                  style: TextStyle(color: Colors.white),
                );
        }),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              authC.logout();
              Get.offAllNamed(RouteName.login);
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Obx(() {
        return (controller.currentIndex.value == 0)
            ? const HomeMain()
            : MainScreen();
      }),
      bottomNavigationBar: CurvedNavigationBar(
        color: const Color.fromARGB(255, 64, 58, 122),
        backgroundColor: Colors.white,
        // buttonBackgroundColor: ,
        items: const [
          Icon(
            Icons.home,
            color: Colors.white,
          ),
          Icon(
            Icons.calendar_month,
            color: Colors.white,
          ),
        ],
        onTap: controller.changeIndex,
      ),
    );
  }
}
