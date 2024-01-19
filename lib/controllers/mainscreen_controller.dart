import 'package:expense_tracker/controllers/database_controller.dart';
import 'package:expense_tracker/controllers/expense%20controller.dart';
import 'package:expense_tracker/controllers/income_controller.dart';
import 'package:expense_tracker/models/thousendformat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/event.dart';

class MainScreenController extends GetxController {
  DateTime focusedDay = DateTime.now();
  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController depositController = TextEditingController();
  TextEditingController unformattedAmountController = TextEditingController();
  TextEditingController unformattedDepositController = TextEditingController();
  Rx<CalendarFormat> calendarFormat = Rx<CalendarFormat>(CalendarFormat.month);
  Rx<DateTime?> selectedDay = Rx<DateTime?>(null);
  List<Event> all = [];
  Map<DateTime, List<Event>> events = {};
  bool initialDataLoaded = false;
  // bool get isEventsInitialized => selectedEvents != null;

  late ValueNotifier<List<Event>> selectedEvents;

  // final depositC = Get.put(DepositController());
  final dbC = Get.put(DatabaseController());
  // final balanceC = Get.put(BalanceController());
  final exC = Get.put(ExpenseController());
  final _incomeC = Get.put(IncomeController());

  @override
  void onInit() async {
    selectedDay.value = focusedDay;

    selectedEvents =
        ValueNotifier<List<Event>>(getEventsForDay(selectedDay.value!));
    await loadEvents();
    ever(selectedDay, (_) {
      selectedEvents.value = getEventsForDay(selectedDay.value!);
    });
    super.onInit();
  }

  Future<void> loadEvents() async {
    try {
      // Fetch events from Firebase
      List<Event> loadedEvents = await dbC.getEvents();

      // Update the 'all' list
      all = loadedEvents;

      // Notify listeners of the selectedEvents ValueNotifier
      selectedEvents.value = getEventsForDay(selectedDay.value!);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(this.selectedDay.value ?? DateTime.now(), selectedDay)) {
      this.focusedDay = focusedDay;
      // this.selectedDay.value = selectedDay;
      this.selectedDay(DateTime.now());
      // selectedEvents.value = getEventsForDay(selectedDay);
      Future.delayed(const Duration(milliseconds: 50), () {
        // print('Before update: ${selectedEvents.value}');
        this.selectedDay.value = selectedDay;
        selectedEvents.value = getEventsForDay(selectedDay);
        // print('After update: ${selectedEvents.value}');
        update();
        // selectedEvents.notifyListeners();
      });
      // print(selectedDay);
      // update();
      // selectedEvents.assignAll(getEventsForDay(selectedDay));
    }
  }

  List<Event> getEventsForDay(DateTime day) {
    return all.where((event) => isSameDay(event.date, day)).toList();
  }

  void onFormatChanged(CalendarFormat format) {
    if (calendarFormat.value != format) {
      calendarFormat.value = format;
    }
  }

  void onPageChanged(DateTime focusedDay) {
    this.focusedDay = focusedDay;
  }

  void addEvent() async {
    if (formKey.currentState!.validate()) {
      if (events[selectedDay] == null) {
        events[selectedDay.value!] = [];
      }
      final int amount = int.parse(amountController.text.replaceAll(',', ''));
      final Event event = Event(
        titleController.text,
        amount,
        selectedDay.value!,
        false,
      );
      await dbC.addEvent(event);
      exC.addExpense(amount);
      events[selectedDay.value!]!.add(
        event,
      );
      all.add(event);
      selectedEvents.value = getEventsForDay(selectedDay.value!);
      Get.back();
      titleController.clear();
      amountController.clear();
    }
  }

  void addIncome() async {
    if (formKey.currentState!.validate()) {
      if (events[selectedDay] == null) {
        events[selectedDay.value!] = [];
      }

      final int amount = int.parse(depositController.text.replaceAll(',', ''));
      final Event event = Event(
        'Income',
        amount,
        selectedDay.value!,
        true,
      );
      await dbC.addEvent(event);
      _incomeC.addIncome(amount, selectedDay.value!);
      events[selectedDay.value!]!.add(
        event,
      );
      all.add(event);
      selectedEvents.value = getEventsForDay(selectedDay.value!);
      Get.back();
      depositController.clear();
    }
  }

  void addExpense() {
    Get.bottomSheet(
      Container(
        height: 500,
        width: double.infinity,
        color: Colors.white,
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: [
                const Center(
                  child: Text(
                    'Add Expense',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.black),
                    // border: OutlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefix: Text('Rp '),
                    labelStyle: TextStyle(color: Colors.black),
                    // border: OutlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Amount';
                    }
                    return null;
                  },
                  inputFormatters: [
                    ThousandsFormatter(),
                  ],
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: addEvent,
                  child: const Text('add'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void deposit() {
    Get.bottomSheet(
      Container(
        height: 500,
        width: double.infinity,
        color: Colors.white,
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: [
                const Center(
                  child: Text(
                    'Deposit',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: depositController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Amount';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefix: Text('Rp '),
                    labelStyle: TextStyle(color: Colors.black),
                    // border: OutlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  inputFormatters: [
                    ThousandsFormatter(),
                  ],
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: addIncome,
                  child: const Text('add'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }
}
