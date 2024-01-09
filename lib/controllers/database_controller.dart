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

  Future<int> getExpense() async {
    try {
      DocumentSnapshot balance = await _db
          .collection('users')
          .doc(_auth.currentUserID())
          .collection('expense')
          .doc(_auth.currentUserID())
          .get();

      if (balance.exists) {
        return balance['expense'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return 0;
    }
  }

  Future<int> getIncome() async {
    try {
      DocumentSnapshot balance = await _db
          .collection('users')
          .doc(_auth.currentUserID())
          .collection('income')
          .doc(_auth.currentUserID())
          .get();

      if (balance.exists) {
        return balance['income'] ?? 0;
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

  Future<void> updateExpense(int expense) async {
    try {
      await _db
          .collection('users')
          .doc(_auth.currentUserID())
          .collection('expense')
          .doc(_auth.currentUserID())
          .set({
        'expense': expense,
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

  Future<void> updateIncome(int income) async {
    try {
      await _db
          .collection('users')
          .doc(_auth.currentUserID())
          .collection('income')
          .doc(_auth.currentUserID())
          .set({
        'income': income,
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Future<void> streamEvents(DateTime date) async {
  //   try {
  //     _db
  //         .collection('users')
  //         .doc(_auth.currentUserID())
  //         .collection('history')
  //         .where('date', isEqualTo: date)
  //         .snapshots()
  //         .listen((event) {
  //       event.docChanges.forEach((element) {
  //         if (element.type == DocumentChangeType.added) {
  //           print(element.doc.data());
  //         }
  //       });
  //     });
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //   }
  // }

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

  Future<int> getExpenseforDay(DateTime day) async {
    DateTime startOfDay = DateTime(day.year, day.month, day.day);
    DateTime endOfDay = DateTime(day.year, day.month, day.day, 23, 59, 59, 999);

    QuerySnapshot querySnapshot = await _db
        .collection('users')
        .doc(_auth.currentUserID())
        .collection('history')
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThanOrEqualTo: endOfDay)
        .get();

    List<Event> events = querySnapshot.docs.map((doc) {
      return Event(
        doc['title'],
        doc['amount'],
        doc['date'].toDate(),
        doc['deposit'],
      );
    }).toList();

    int sumDeposits = events
        .where((event) => event.deposit == false)
        .fold(0, (previousValue, element) => previousValue + element.amount);

    return sumDeposits;
  }

  Future<int> getExpenseforWeek(
      DateTime startOfWeek, DateTime endOfWeek) async {
    QuerySnapshot querySnapshot = await _db
        .collection('users')
        .doc(_auth.currentUserID())
        .collection('history')
        .where('date', isGreaterThanOrEqualTo: startOfWeek)
        .where('date', isLessThanOrEqualTo: endOfWeek)
        // .where('deposit', isEqualTo: false)
        .get();

    List<Event> events = querySnapshot.docs.map((doc) {
      return Event(
        doc['title'],
        doc['amount'],
        doc['date'].toDate(),
        doc['deposit'],
      );
    }).toList();
    int sumDeposits = events
        .where((event) => event.deposit == false)
        .fold(0, (previousValue, element) => previousValue + element.amount);

    return sumDeposits;
  }

  Future<int> getExpenseforMonth(DateTime month) async {
    DateTime startOfMonth = DateTime(month.year, month.month, 1);
    DateTime endOfMonth =
        DateTime(month.year, month.month + 1, 0, 23, 59, 59, 999);

    QuerySnapshot querySnapshot = await _db
        .collection('users')
        .doc(_auth.currentUserID())
        .collection('history')
        .where('date', isGreaterThanOrEqualTo: startOfMonth)
        .where('date', isLessThanOrEqualTo: endOfMonth)
        .get();

    List<Event> events = querySnapshot.docs.map((doc) {
      return Event(
        doc['title'],
        doc['amount'],
        doc['date'].toDate(),
        doc['deposit'],
      );
    }).toList();

    int sumDeposits = events
        .where((event) => event.deposit == false)
        .fold(0, (previousValue, element) => previousValue + element.amount);

    return sumDeposits;
  }

  Future<int> getIncomeforDay(DateTime day) async {
    DateTime startOfDay = DateTime(day.year, day.month, day.day);
    DateTime endOfDay = DateTime(day.year, day.month, day.day, 23, 59, 59, 999);

    QuerySnapshot querySnapshot = await _db
        .collection('users')
        .doc(_auth.currentUserID())
        .collection('history')
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThanOrEqualTo: endOfDay)
        .get();

    List<Event> events = querySnapshot.docs.map((doc) {
      return Event(
        doc['title'],
        doc['amount'],
        doc['date'].toDate(),
        doc['deposit'],
      );
    }).toList();

    int sumDeposits = events
        .where((event) => event.deposit)
        .fold(0, (previousValue, element) => previousValue + element.amount);

    return sumDeposits;
  }

  Future<int> getIncomeforWeek(DateTime startOfWeek, DateTime endOfWeek) async {
    QuerySnapshot querySnapshot = await _db
        .collection('users')
        .doc(_auth.currentUserID())
        .collection('history')
        .where('date', isGreaterThanOrEqualTo: startOfWeek)
        .where('date', isLessThanOrEqualTo: endOfWeek)
        // .where('deposit', isEqualTo: false)
        .get();

    List<Event> events = querySnapshot.docs.map((doc) {
      return Event(
        doc['title'],
        doc['amount'],
        doc['date'].toDate(),
        doc['deposit'],
      );
    }).toList();
    int sumDeposits = events
        .where((event) => event.deposit)
        .fold(0, (previousValue, element) => previousValue + element.amount);

    return sumDeposits;
  }

  Future<int> getIncomeforMonth(DateTime month) async {
    DateTime startOfMonth = DateTime(month.year, month.month, 1);
    DateTime endOfMonth =
        DateTime(month.year, month.month + 1, 0, 23, 59, 59, 999);

    QuerySnapshot querySnapshot = await _db
        .collection('users')
        .doc(_auth.currentUserID())
        .collection('history')
        .where('date', isGreaterThanOrEqualTo: startOfMonth)
        .where('date', isLessThanOrEqualTo: endOfMonth)
        .get();

    List<Event> events = querySnapshot.docs.map((doc) {
      return Event(
        doc['title'],
        doc['amount'],
        doc['date'].toDate(),
        doc['deposit'],
      );
    }).toList();

    int sumDeposits = events
        .where((event) => event.deposit)
        .fold(0, (previousValue, element) => previousValue + element.amount);

    return sumDeposits;
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
