import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/controllers/auth_controller.dart';
import 'package:expense_tracker/controllers/mainscreen_controller.dart';
import 'package:expense_tracker/models/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import 'event_list.dart';

final db = FirebaseFirestore.instance;

class MainScreen extends GetView<MainScreenController> {
  MainScreen({super.key});
  final mainC = Get.put(MainScreenController());

  @override
  Widget build(BuildContext context) {
    final auth = Get.put(AuthController());
    return Scaffold(
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add),
            label: 'Add Expense',
            onTap: controller.addExpense,
          ),
          SpeedDialChild(
            child: const Icon(Icons.attach_money),
            label: 'Deposit',
            onTap: controller.deposit,
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: db
              .collection('users')
              .doc(auth.currentUserID())
              .collection('history')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if (!controller.initialDataLoaded) {
              if (snapshot.hasData && snapshot.data != null) {
                controller.all = snapshot.data!.docs.map<Event>(
                  (data) {
                    return Event(
                      data['title'],
                      data['amount'],
                      data['date'].toDate(),
                      data['deposit'],
                    );
                  },
                ).toList();
              }
              controller.initialDataLoaded = true;
            }

            // if (!controller.initialDataLoaded) {
            //   controller.all = snapshot.data!.docs.map<Event>(
            //     (data) {
            //       return Event(
            //         data['title'],
            //         data['amount'],
            //         data['date'].toDate(),
            //         data['deposit'],
            //       );
            //     },
            //   ).toList();
            //   controller.initialDataLoaded = true;
            // }
            return Column(
              children: [
                Obx(
                  () {
                    DateTime? selectedDay = controller.selectedDay.value;
                    return TableCalendar(
                      focusedDay: controller.focusedDay,
                      firstDay: DateTime(2022),
                      lastDay: DateTime(2030),
                      calendarFormat: controller.calendarFormat.value,
                      rowHeight: 50,
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: true,
                        titleCentered: true,
                      ),
                      selectedDayPredicate: (day) =>
                          isSameDay(day, selectedDay),
                      onDaySelected: controller.onDaySelected,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      availableGestures: AvailableGestures.all,
                      eventLoader: controller.getEventsForDay,
                      onFormatChanged: controller.onFormatChanged,
                      onPageChanged: controller.onPageChanged,
                      calendarStyle: const CalendarStyle(
                        isTodayHighlighted: true,
                        selectedDecoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle: TextStyle(color: Colors.white),
                        todayDecoration: BoxDecoration(
                          color: Colors.purpleAccent,
                          shape: BoxShape.circle,
                        ),
                        defaultDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        weekendDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
                Obx(
                  () => Text(controller.selectedDay.toString().split(" ")[0]),
                ),
                EventList(controller: controller),
              ],
            );
          }),
    );
  }
}
