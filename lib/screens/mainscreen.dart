import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/controllers/auth_controller.dart';
import 'package:expense_tracker/controllers/database_controller.dart';
import 'package:expense_tracker/controllers/mainscreen_controller.dart';
import 'package:expense_tracker/models/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:expense_tracker/currency.dart';

// final auth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;

class MainScreen extends GetView<MainScreenController> {
  MainScreen({super.key});
  final mainC = Get.put(MainScreenController());

  @override
  Widget build(BuildContext context) {
    // final dbC = Get.put(DatabaseController());
    final auth = Get.put(AuthController());
    // List<Event> _all = [];
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
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: controller.all.length,
                //     itemBuilder: (context, index) {
                //       return Card(
                //         child: ListTile(
                //           title: Text(controller.all[index].title),
                //           subtitle: Text(
                //             CurrencyFormat.convertToIdr(
                //                 controller.all[index].amount, 0),
                //           ),
                //           trailing: IconButton(
                //             icon: const Icon(Icons.print),
                //             onPressed: () {
                //               print(controller.all);
                //             },
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                // Expanded(
                //   child: StreamBuilder(
                //     stream: db
                //         .collection('users')
                //         .doc(auth.currentUserID())
                //         .collection('history')
                //         .where('date', isEqualTo: controller.selectedDay)
                //         .snapshots(),
                //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                //       if (snapshot.hasError) {
                //         return const Text('Something went wrong');
                //       }

                //       if (snapshot.connectionState == ConnectionState.waiting) {
                //         return const Text("Loading");
                //       }

                //       if (snapshot.data!.docs.isEmpty) {
                //         return const Center(
                //           child: Text('No posts available.'),
                //         );
                //       }

                //       return ListView(
                //         children:
                //             snapshot.data!.docs.map((DocumentSnapshot document) {
                //           Map<String, dynamic> data =
                //               document.data()! as Map<String, dynamic>;
                //           return Card(
                //             child: ListTile(
                //               title: Text(data['title']),
                //               subtitle: Text(
                //                   CurrencyFormat.convertToIdr(data['amount'], 0)),
                //             ),
                //           );
                //         }).toList(),
                //       );
                //     },
                //   ),
                // ),
                // Expanded(
                //   child: ValueListenableBuilder<List<Event>>(
                //     valueListenable: controller.selectedEvents,
                //     builder: (context, value, _) {
                //       return ListView.builder(
                //         itemCount: value.length,
                //         itemBuilder: (context, index) {
                //           return Card(
                //             child: ListTile(
                //               title: Text(value[index].title),
                //               subtitle: Text(
                //                 CurrencyFormat.convertToIdr(value[index].amount, 0),
                //               ),
                //               trailing: IconButton(
                //                 icon: const Icon(Icons.print),
                //                 onPressed: () {
                //                   print(value);
                //                 },
                //               ),
                //             ),
                //           );
                //         },
                //       );
                //     },
                //   ),
                // ),
                // Obx(
                //   () {
                //     controller.getEventsForDay(controller.selectedDay.value).map(
                //           (Event event) => ListTile(
                //             title: Text(event.title),
                //             subtitle:
                //                 Text(CurrencyFormat.convertToIdr(event.amount, 0)),
                //             trailing: IconButton(
                //               icon: const Icon(Icons.print),
                //               onPressed: () {
                //                 print(event);
                //               },
                //             ),
                //           ),
                //         );
                //     // .toList(),)
                //   },
                // ),
                Expanded(
                  child: ValueListenableBuilder<List<Event>>(
                    valueListenable: controller.selectedEvents,
                    builder: (context, value, _) {
                      return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(value[index].title),
                              subtitle: Text(
                                  CurrencyFormat.convertToIdr(
                                    value[index].amount,
                                    0,
                                  ),
                                  style: TextStyle(
                                    color: value[index].deposit
                                        ? Colors.green
                                        : Colors.red,
                                  )),
                              leading: Icon(value[index].deposit
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward),
                              // trailing: IconButton(
                              //   icon: const Icon(Icons.print),
                              //   onPressed: () {
                              //     print(value);
                              //   },
                              // ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                // Expanded(
                //   child: Obx(() {
                //     return ListView.builder(
                //       itemCount: controller.selectedEvents.length,
                //       itemBuilder: (context, index) {
                //         return Card(
                //           child: ListTile(
                //             title: Text(controller.selectedEvents[index].title),
                //             subtitle: Text(
                //               CurrencyFormat.convertToIdr(
                //                   controller.selectedEvents[index].amount, 0),
                //             ),
                //             trailing: IconButton(
                //               icon: const Icon(Icons.print),
                //               onPressed: () {
                //                 print(controller.selectedEvents);
                //               },
                //             ),
                //           ),
                //         );
                //       },
                //     );
                //   }),
                // ),
              ],
            );
          }),
    );
  }
}
