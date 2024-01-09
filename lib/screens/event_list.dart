import 'package:expense_tracker/controllers/mainscreen_controller.dart';
import 'package:expense_tracker/currency.dart';
import 'package:expense_tracker/models/event.dart';
import 'package:flutter/material.dart';

class EventList extends StatelessWidget {
  const EventList({
    super.key,
    required this.controller,
  });

  final MainScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                      2,
                    ),
                    style: TextStyle(
                      color: value[index].deposit ? Colors.green : Colors.red,
                    ),
                  ),
                  leading: (value[index].deposit)
                      ? (const Icon(
                          Icons.arrow_upward,
                          color: Colors.green,
                        ))
                      : (const Icon(
                          Icons.arrow_downward,
                          color: Colors.red,
                        )),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
