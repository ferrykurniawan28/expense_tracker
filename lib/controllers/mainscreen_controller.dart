import 'package:expense_tracker/controllers/balance_controller.dart';
import 'package:expense_tracker/controllers/database_controller.dart';
import 'package:expense_tracker/controllers/deposit_cotroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/event.dart';

class MainScreenController extends GetxController {
  DateTime focusedDay = DateTime.now();
  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  Rx<CalendarFormat> calendarFormat = Rx<CalendarFormat>(CalendarFormat.month);
  // DateTime? selectedDay;
  Rx<DateTime?> selectedDay = Rx<DateTime?>(null);
  List<Event> all = [];
  Map<DateTime, List<Event>> events = {
    DateTime.now(): [
      Event(
        'No events',
        0,
        DateTime.now(),
        false,
      ),
      Event(
        'No events',
        0,
        DateTime.now(),
        false,
      ),
    ],
  };
  // RxList<Event> selectedEvents = <Event>[].obs;
  // late final ValueNotifier<List<Event>> selectedEvents;
  // late final RxList<Event> selectedEvents;

  late final ValueNotifier<List<Event>> selectedEvents;
  // RxMap<DateTime, List<Event>> events = {}.obs;
  // RxMap<DateTime, List<Event>> events = RxMap<DateTime, List<Event>>.from({});

  final depositC = Get.put(DepositController());
  final dbC = Get.put(DatabaseController());
  final balanceC = Get.put(BalanceController());

  @override
  void onInit() async {
    selectedDay.value = focusedDay;
    loadEvents();
    selectedEvents =
        ValueNotifier<List<Event>>(getEventsForDay(selectedDay.value!));
    // selectedEvents = RxList<Event>(getEventsForDay(selectedDay.value!));
    super.onInit();
  }

  // void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
  //   if (!isSameDay(this.selectedDay.value ?? DateTime.now(), selectedDay)) {
  //     this.focusedDay = focusedDay;
  //     this.selectedDay(DateTime.now());

  //     Future.delayed(const Duration(milliseconds: 50), () {
  //       this.selectedDay.value = selectedDay;
  //       selectedEvents.value = getEventsForDay(selectedDay);
  //       update(); // Trigger a rebuild
  //     });
  //   }
  // }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(this.selectedDay.value ?? DateTime.now(), selectedDay)) {
      this.focusedDay = focusedDay;
      // this.selectedDay.value = selectedDay;
      this.selectedDay(DateTime.now());
      // selectedEvents.value = getEventsForDay(selectedDay);
      Future.delayed(const Duration(milliseconds: 50), () {
        print('Before update: ${selectedEvents.value}');
        this.selectedDay.value = selectedDay;
        selectedEvents.value = getEventsForDay(selectedDay);
        print('After update: ${selectedEvents.value}');
        update();
        // selectedEvents.notifyListeners();
      });
      // print(selectedDay);
      // update();
      // selectedEvents.assignAll(getEventsForDay(selectedDay));
    }
  }

  Future<void> loadEvents() async {
    try {
      List<Event> loadedEvents = await dbC.getEvents();
      // print(loadedEvents);

      for (Event event in loadedEvents) {
        DateTime date = event.date;
        if (events[date] == null) {
          events[date] = [];
        }
        Event eventL = Event(
          event.title,
          event.amount,
          event.date,
          event.deposit,
        );
        events[date]!.add(eventL);
        // print(event.date);
        // print(event.amount);
        // print(event.title);
        // print(event.deposit);
        // print(eventL.date);
        // print(events[date].toString());
        // print('all $events');
        selectedEvents.value = getEventsForDay(selectedDay.value!);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Map<DateTime, List<Event>> groupEventsByDate(List<Event> eventsList) {
    Map<DateTime, List<Event>> groupedEvents = {};
    for (Event event in eventsList) {
      DateTime date = event.date;
      if (groupedEvents[date] == null) {
        groupedEvents[date] = [];
      }
      groupedEvents[date]!.add(event);
    }
    return groupedEvents;
  }

  // Future<void> loadEvents() async {
  //   try {
  //     List<Event> loadedEvents = await dbC.getEvents();
  //     // print(loadedEvents);

  //     // Filter events per week
  //     List<Event> filteredEvents = loadedEvents.where((event) {
  //       return isSameDay(event.date, focusedDay);
  //     }).toList();

  //     // Group filtered events by date
  //     events = groupEventsByDate(filteredEvents);
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //   }
  // }

  List<Event> getEventsForDay(DateTime day) {
    return all.where((event) => isSameDay(event.date, day)).toList();
  }

  // List<Event> getEventsForDay(DateTime day) {
  //   return events[day] ??
  //       [
  //         // Event(
  //         //   'No events',
  //         //   0,
  //         //   day,
  //         //   false,
  //         // ),
  //         // Event(
  //         //   'No events',
  //         //   0,
  //         //   day,
  //         //   false,
  //         // ),
  //       ];
  // }

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
      final int amount = int.parse(amountController.text);
      final Event event = Event(
        titleController.text,
        amount,
        selectedDay.value!,
        false,
      );
      // await dbC.addEvent(event);
      balanceC.addExpense(amount);
      events[selectedDay]!.add(
        Event(
          titleController.text,
          int.parse(amountController.text),
          selectedDay.value!,
          false,
        ),
      );
      titleController.clear();
      amountController.clear();
      selectedEvents.value = getEventsForDay(selectedDay.value!);
      Get.back();
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
          key: depositC.form,
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
                  controller: depositC.depositController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Amount';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Amount',
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
                ElevatedButton(
                  // onPressed: () {},
                  onPressed: () => depositC.addDeposit(selectedDay.value!),
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
