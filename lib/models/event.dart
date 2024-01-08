import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String title;
  final int amount;
  final DateTime date;
  final bool deposit;
  Event(this.title, this.amount, this.date, this.deposit);

  static fromMap(Map<String, dynamic> data) {
    return Event(
      data['title'],
      data['amount'],
      data['date'],
      data['deposit'],
    );
  }

  factory Event.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      [SnapshotOptions? options]) {
    final data = snapshot.data()!;
    return Event(
      data['title'],
      data['amount'],
      data['date'].toDate(),
      data['deposit'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'date': date,
      'deposit': deposit,
    };
  }
}
