import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/event.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

class DatabaseController extends GetxController {
  final _db = FirebaseFirestore.instance;
  final _auth = Get.put(AuthController());

  Future<int> getBalance() async {
    try {
      DocumentSnapshot balance = await _db
          .collection('users')
          .doc(_auth.currentUserID())
          .collection('balance')
          .doc(_auth.currentUserID())
          .get();

      if (balance.exists) {
        return balance['balance'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return 0;
    }
  }

  Future<int> getTargetBalance() async {
    try {
      DocumentSnapshot balance = await _db
          .collection('users')
          .doc(_auth.currentUserID())
          .collection('targetbalance')
          .doc(_auth.currentUserID())
          .get();

      if (balance.exists) {
        return balance['target'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return 0;
    }
  }

  Future<void> updateTargetBalance(int balance) async {
    try {
      await _db
          .collection('users')
          .doc(_auth.currentUserID())
          .collection('targetbalance')
          .doc(_auth.currentUserID())
          .set({
        'target': balance,
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> updateBalance(int balance) async {
    try {
      await _db
          .collection('users')
          .doc(_auth.currentUserID())
          .collection('balance')
          .doc(_auth.currentUserID())
          .set({
        'balance': balance,
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> streamEvents(DateTime date) async {
    try {
      _db
          .collection('users')
          .doc(_auth.currentUserID())
          .collection('history')
          .where('date', isEqualTo: date)
          .snapshots()
          .listen((event) {
        event.docChanges.forEach((element) {
          if (element.type == DocumentChangeType.added) {
            print(element.doc.data());
          }
        });
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<List<Event>> getEvents() async {
    try {
      QuerySnapshot events = await _db
          .collection('users')
          .doc(_auth.currentUserID())
          .collection('history')
          .get();

      return events.docs.map((QueryDocumentSnapshot e) {
        Map<String, dynamic> data = e.data() as Map<String, dynamic>;

        Timestamp timestamp = data['date'];
        DateTime date = timestamp.toDate();

        Event event = Event(
          data['title'],
          data['amount'],
          date,
          data['deposit'],
        );

        return event;
      }).toList();
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return [];
    }
  }

  // Future<List<Event>> getEvents() async {
  //   try {
  //     QuerySnapshot events = await _db
  //         .collection('users')
  //         .doc(_auth.currentUserID())
  //         .collection('history')
  //         .get();
  //     // print(events);
  //     return events.docs.map((e) {
  //       Timestamp timestamp = e['date'];
  //       DateTime date = timestamp.toDate();
  //       print(e);
  //       Event event = Event(
  //         e['title'],
  //         e['amount'],
  //         date,
  //         e['deposit'],
  //       );
  //       print(event);
  //       return event;
  //     }).toList();
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //     return [];
  //   }
  // }

  Future<void> addEvent(Event data) async {
    try {
      await _db
          .collection('users')
          .doc(_auth.currentUserID())
          .collection('history')
          .add({
        'title': data.title,
        'amount': data.amount,
        'date': data.date,
        'deposit': data.deposit,
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> createAccount(String name, String email, String password) async {
    try {
      await _db.collection('users').doc(_auth.currentUserID()).set({
        'name': name,
        'email': email,
        'password': password,
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> addIncome(String title, String amount) async {
    try {
      await _db.collection('incomes').add({
        'title': title,
        'amount': amount,
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> addExpense(String title, String amount) async {
    try {
      await _db.collection('expenses').add({
        'title': title,
        'amount': amount,
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await _db.collection('expenses').doc(id).delete();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
