import 'package:cloud_firestore/cloud_firestore.dart';

String formatTimestamp(Timestamp timestamp) {
  final DateTime dt = timestamp.toDate();

  return "${dt.day.toString().padLeft(2, '0')}/"
      "${dt.month.toString().padLeft(2, '0')}/"
      "${dt.year} "
      "${(dt.hour % 12 == 0 ? 12 : dt.hour % 12).toString().padLeft(2, '0')}:"
      "${dt.minute.toString().padLeft(2, '0')} "
      "${dt.hour >= 12 ? "PM" : "AM"}";
}
