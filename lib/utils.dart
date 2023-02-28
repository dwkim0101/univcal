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
  Map<DateTime, bool> reviewState = {};
  // TODO: event delete screen / landing page

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

@HiveType(typeId: 2)
class NonRepeatableEvent {
  //받고 나면 event로 치환.
  @HiveField(0)
  String title;
  @HiveField(1)
  DateTime date;

  NonRepeatableEvent(
    this.title,
    this.date,
  );

  @override
  String toString() => title;
}

LinkedHashMap<DateTime, List<Event>> kEvents =
    LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
); //데일리 반복 모두 있는 이벤트 리스트

List<RepeatableEvent> repeatingEvents = [];
List<NonRepeatableEvent> dailyEvents = [];

// final _kEventSource = {
//   for (var item in List.generate(50, (index) => index))
//     DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5): List.generate(
//         item % 4 + 1, (index) => Event('Event $item | ${index + 1}'))
// }..addAll({
//     kToday: [
//       Event('Today\'s Event 1'),
//       Event('Today\'s Event 2'),
//     ],
//   });

int getHashCode(DateTime key) {
  return key.year * 10000 + key.month * 100 + key.day;
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

void kEventUpdate() {
  //반복 이벤트 생성
  for (var _ in repeatingEvents) {
    for (DateTime currentDay in daysInRange(_.startDay, _.endDay)) {
      if (_.repeatWeekdays[currentDay.weekday - 1]) {
        if (kEvents[currentDay] == null) {
          kEvents.addAll({
            currentDay: [Event(_.title)]
          });
        } else {
          kEvents[currentDay]?.add(Event(_.title));
        }
      }
    }
  }
  for (var _ in dailyEvents) {
    if (kEvents[_.date] == null) {
      kEvents.addAll({
        _.date: [Event(_.title)]
      });
    } else {
      kEvents[_.date]?.add(Event(_.title));
    }
  }
}
