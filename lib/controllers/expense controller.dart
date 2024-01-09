import 'package:expense_tracker/controllers/balance_controller.dart';
import 'package:expense_tracker/controllers/database_controller.dart';
import 'package:get/get.dart';

class ExpenseController extends GetxController {
  var expense = 0.obs;
  var expenseforDay = 0.obs;
  var expenseforWeek = 0.obs;
  var expenseforMonth = 0.obs;

  DateTime startOfWeek = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day - DateTime.now().weekday + 1);
  late DateTime endOfWeek;
  final DateTime today = DateTime.now();

  final _balanceController = Get.put(BalanceController());
  final _dbC = Get.put(DatabaseController());

  @override
  void onInit() async {
    endOfWeek = startOfWeek.add(const Duration(days: 6));
    expense.value = await _dbC.getExpense();
    expenseforDay.value = await _dbC.getExpenseforDay(today);
    expenseforWeek.value = await _dbC.getExpenseforWeek(startOfWeek, endOfWeek);
    expenseforMonth.value = await _dbC.getExpenseforMonth(today);
    super.onInit();
  }

  void addExpense(int amount) async {
    expense.value += amount;
    _balanceController.addExpense(amount);
    await _dbC.updateExpense(expense.value);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
