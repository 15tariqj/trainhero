import 'package:flutter/material.dart';

class Departure {
  final TimeOfDay arrivalTime;
  final TimeOfDay departureTime;
  final String toc;

  Departure({
    required this.arrivalTime,
    required this.departureTime,
    required this.toc,
  });

  factory Departure.fromJson(Map<String, dynamic> json) {
    String arrTimeStr = json['arrTime'];
    String depTimeStr = json['depTime'];
    return Departure(
      arrivalTime: TimeOfDay(hour: int.parse(arrTimeStr.substring(0, 2)), minute: int.parse(arrTimeStr.substring(0, 2))),
      departureTime: TimeOfDay(hour: int.parse(depTimeStr.substring(0, 2)), minute: int.parse(depTimeStr.substring(0, 2))),
      toc: json['toc'],
    );
  }
}
