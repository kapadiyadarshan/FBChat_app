import 'package:flutter/material.dart';

Widget TimeWidget({required DateTime time, required String type}) {
  DateTime dt = time;
  Duration day = DateTime.now().difference(dt);
  String date = "";
  date =
      "${dt.hour % 12 == 0 ? 12 : dt.hour % 12}:${"${dt.minute}".padLeft(2, "0")} ${(dt.hour > 12) ? "PM" : "AM"}";

  return Text(
    date,
    style: TextStyle(
      fontSize: 10,
      color: (type == 'sent') ? Colors.white.withOpacity(0.8) : Colors.grey,
    ),
  );
}

Widget homeTimeWidget({required DateTime time, required String type}) {
  DateTime dt = time;
  Duration day = DateTime.now().difference(dt);
  String date = "";
  date =
      "${dt.hour % 12 == 0 ? 12 : dt.hour % 12}:${"${dt.minute}".padLeft(2, "0")} ${(dt.hour > 12) ? "PM" : "AM"}";

  return Text(
    date,
    style: const TextStyle(
      fontSize: 10,
    ),
  );
}
