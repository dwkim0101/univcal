// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'dart:core';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

part 'utils.g.dart';

final box = Hive.openBox('mybox');

/// Example event class.
@HiveType(typeId: 0)
class Event {
  @HiveField(0)
  final String title;
  @HiveField(1)
  bool checkState = false;

  @HiveField(2)
  late Map<DateTime, bool> reviewState;
  // TODO: event data / event delete screen / landing page

  Event(this.title);

  @override
  String toString() => title;
}

@HiveType(typeId: 1)
class RepeatableEvent {
  //받고 나면 event로 치환.
  @HiveField(0)
  String title;
  @HiveField(1)
  DateTime startDay;
  @HiveField(2)
  DateTime endDay;

  @HiveField(3)
  List<bool> repeatWeekdays = List.filled(7, false); //월 ~ 일

  RepeatableEvent({
    required this.title,
    required this.startDay,
    required this.endDay,
    required this.repeatWeekdays,
  });

  void printNewClass() {
    print("$title, $startDay, $endDay, $repeatWeekdays");
  }

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
LinkedHashMap<DateTime, List<Event>> kEvents =
    LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

LinkedHashMap<DateTime, List<Event>> dailyEvents =
    LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
);

List<RepeatableEvent> repeatingEvents = [];

final _kEventSource = {
  for (var item in List.generate(50, (index) => index))
    DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5): List.generate(
        item % 4 + 1, (index) => Event('Event $item | ${index + 1}'))
}..addAll({
    kToday: [
      Event('Today\'s Event 1'),
      Event('Today\'s Event 2'),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 6, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 6, kToday.day);
