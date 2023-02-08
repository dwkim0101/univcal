// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils.dart';

class CalendarEvents extends StatefulWidget {
  const CalendarEvents({super.key});

  @override
  State<CalendarEvents> createState() => _CalendarEventsState();
}

class _CalendarEventsState extends State<CalendarEvents> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.green.withOpacity(0.0),
        ),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            locale: 'ko-kr',
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            availableCalendarFormats: const {
              CalendarFormat.month: '월별 보기',
              CalendarFormat.twoWeeks: '2주 보기',
              CalendarFormat.week: '주별 보기',
            },
            weekendDays: const [DateTime.sunday],
            headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonTextStyle:
                  TextStyle(color: Colors.white, fontSize: 13),
              formatButtonDecoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.fromBorderSide(
                      BorderSide(color: Colors.blue, width: 2)),
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
            ),
            calendarStyle: const CalendarStyle(
              selectedDecoration:
                  BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
              markersMaxCount: 1,
              // markerDecoration: BoxDecoration(),
              markerSize: 5,
              todayTextStyle: TextStyle(
                  color: Colors.blueAccent, fontWeight: FontWeight.w900),
              todayDecoration: BoxDecoration(
                  color: Colors.transparent, shape: BoxShape.circle),
              isTodayHighlighted: true,
              weekendTextStyle: TextStyle(
                  color: Colors.deepOrange, fontWeight: FontWeight.bold),
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 0),
          Expanded(
            child: _getEventsForDay(_selectedDay!).isEmpty
                ? Transform.translate(
                    offset: const Offset(0, 20),
                    child: Container(
                      margin: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border:
                            Border.all(color: Colors.blueAccent, width: 2.5),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 3,
                          ),
                          Expanded(
                            child: Center(
                              child: Transform.translate(
                                offset: const Offset(0, -20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      CupertinoIcons.check_mark_circled,
                                      color: Colors.blue,
                                      size: 80,
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.only(left: 15),
                                      child: const Text(
                                        '학습 할 내용이 없습니다!',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                        ),
                                      ), //일정 없을 시
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Transform.translate(
                    offset: const Offset(0, 20),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border:
                            Border.all(color: Colors.blueAccent, width: 2.5),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: ValueListenableBuilder<List<Event>>(
                        valueListenable: _selectedEvents,
                        builder: (context, value, _) {
                          return ListView.builder(
                            padding: const EdgeInsets.all(0),
                            itemCount: value.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.all(0),
                                margin: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                decoration: const BoxDecoration(
                                  border:
                                      Border(bottom: BorderSide(width: 0.3)),
                                ),
                                child: ListTile(
                                  trailing: value[index].checkState
                                      ? const Icon(
                                          CupertinoIcons
                                              .check_mark_circled_solid,
                                          color: Colors.blue,
                                        )
                                      : const Icon(CupertinoIcons.circle),
                                  onTap: () => {
                                    setState(() {
                                      value[index].checkState =
                                          !(value[index].checkState);
                                    })
                                  },
                                  title: Text(
                                    '${value[index]}',
                                    style: TextStyle(
                                        color: value[index].checkState
                                            ? Colors.grey
                                            : Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        decoration: value[index].checkState
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(
                Alignment.bottomRight.x, Alignment.bottomRight.y - 0.2),
            child: FloatingActionButton(
              onPressed: () {
                setState(() => _onDaySelected(DateTime.now(), DateTime.now()));
              },
              tooltip: 'TODAY',
              child: const Icon(CupertinoIcons.refresh),
            ),
          ),
          const Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: null,
              child: Icon(CupertinoIcons.add),
            ),
          ),
        ],
      ),
    );
  }
}
