// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'dart:core';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

part 'utils.g.dart';

final box = Hive.openBox('mybox2');
int currentParentIndex = 0;
bool isAdded = false;

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
  @HiveField(3)
  final bool repeatable;
  @HiveField(4)
  final int index;

  Event({
    required this.title,
    required this.checkState,
    required this.reviewState,
    required this.repeatable,
    required this.index,
  });

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
  @HiveField(4)
  final int index;

  RepeatableEvent({
    required this.title,
    required this.startDay,
    required this.endDay,
    required this.repeatWeekdays,
    required this.index,
  });

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
  @HiveField(2)
  bool checkState = false;

  @HiveField(3)
  Map<DateTime, bool> reviewState = {};
  @HiveField(4)
  int index;
  @HiveField(5)
  int? parentIndex;

  NonRepeatableEvent({
    required this.title,
    required this.date,
    required this.index,
    this.parentIndex,
  });

  @override
  String toString() => title;
}

LinkedHashMap<DateTime, List<Event>> kEvents =
    LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
);

//데일리 반복 모두 있는 이벤트 리스트
//왜 하이브에 KEVENT가 저장이 안될까요???????????????????????????????
List<RepeatableEvent> repeatingEvents = [];
List<NonRepeatableEvent> convertedRepeatingEvents = [];
List<NonRepeatableEvent> dailyEvents = [];
//그래서 저장 안하기로 했구요, dailyEvent, convertedRepeatingEvents로 쇼부 봅시다.

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
  // ignore: prefer_collection_literals
  kEvents = LinkedHashMap<DateTime, List<Event>>();

  for (var _ in convertedRepeatingEvents) {
    // print(_.index);
    if (kEvents[_.date] == null) {
      kEvents.addAll({
        _.date: [
          Event(
            title: _.title,
            checkState: _.checkState,
            reviewState: _.reviewState,
            repeatable: true,
            index: _.index,
          )
        ]
      });
    } else {
      // print('nulln');
      kEvents[_.date]?.add(Event(
          title: _.title,
          checkState: _.checkState,
          reviewState: _.reviewState,
          repeatable: true,
          index: _.index));
    }
  }
  // print(kEvents);
  for (var _ in dailyEvents) {
    if (kEvents[_.date] == null) {
      kEvents.addAll({
        _.date: [
          Event(
            title: _.title,
            checkState: _.checkState,
            reviewState: _.reviewState,
            repeatable: false,
            index: _.index,
          )
        ]
      });
    } else {
      kEvents[_.date]?.add(
        Event(
          title: _.title,
          checkState: _.checkState,
          reviewState: _.reviewState,
          repeatable: false,
          index: _.index,
        ),
      );
    }
  }
}

void repeatConverter() {
  //반복 이벤트 생성
  for (var _ in repeatingEvents) {
    for (DateTime currentDay in daysInRange(_.startDay, _.endDay)) {
      if (_.repeatWeekdays[currentDay.weekday - 1]) {
        int tempIndex = convertedRepeatingEvents.length;
        convertedRepeatingEvents.add(NonRepeatableEvent(
          title: _.title,
          date: currentDay,
          index: tempIndex,
          parentIndex: _.index,
        ));
      }
    }
  }
}

final List<String> dateNameList = ['월', '화', '수', '목', '금', '토', '일'];
final List<String> dateNameListEng = [
  'MON',
  'TUE',
  'WED',
  'THUR',
  'FRI',
  'SAT',
  'SUN'
];
String makeWeekDaysString(List<bool> weekdays) {
  String returnString = "";
  for (int i = 0; i < weekdays.length; i++) {
    if (weekdays[i]) {
      if (returnString.isNotEmpty) {
        returnString += ", ";
      }
      returnString += dateNameList[i];
    }
  }
  // print(returnString);
  return returnString;
}
