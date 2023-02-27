// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils.dart';

class CalendarEvents extends StatefulWidget {
  const CalendarEvents({super.key});

  @override
  State<CalendarEvents> createState() => _CalendarEventsState();
}

class _CalendarEventsState extends State<CalendarEvents> {
  final textController = TextEditingController();
  DateTime? _currentDay;
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
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
      textController.text =
          DateFormat('yyyy/MM/dd').format(_selectedDay ?? DateTime.now());
      _currentDay = selectedDay;
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
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
                titleCentered: false,
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
                todayTextStyle:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.w900),
                todayDecoration: BoxDecoration(
                    color: Colors.transparent, shape: BoxShape.circle),
                isTodayHighlighted: true,
                weekendTextStyle: TextStyle(
                    color: Colors.deepOrange, fontWeight: FontWeight.bold),
                // Use `CalendarStyle` to customize the UI
                outsideDaysVisible: false,
              ),
              onDaySelected: _onDaySelected,
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
                        margin: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade500,
                          border: Border.all(
                              color: Colors.grey.shade500, width: 2.5),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(35),
                            topRight: Radius.circular(35),
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
                                        CupertinoIcons.rays,
                                        color: Colors.white,
                                        size: 60,
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        alignment: Alignment.center,
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: const Text(
                                          '학습 할 내용이 없습니다',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
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
                        margin: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          border: Border.all(color: Colors.blue, width: 2.5),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(35),
                            topRight: Radius.circular(35),
                          ),
                        ),
                        child: ValueListenableBuilder<List<Event>>(
                          valueListenable: _selectedEvents,
                          builder: (context, value, _) {
                            return ListView.builder(
                              padding: const EdgeInsets.all(0),
                              itemCount: value.length,
                              physics: const ScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: const EdgeInsets.all(0),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1.5, color: Colors.white)),
                                  ),
                                  child: ListTile(
                                    // enableFeedback: true,
                                    // selectedTileColor: Colors.blueAccent,
                                    trailing: value[index].checkState
                                        ? const Icon(
                                            CupertinoIcons
                                                .check_mark_circled_solid,
                                            color: Colors.white,
                                          )
                                        : const Icon(
                                            CupertinoIcons.circle,
                                            color: Colors.white,
                                          ),
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
                                            ? Colors.white.withOpacity(0.6)
                                            : Colors.white,
                                        fontSize: 16,
                                        fontWeight: value[index].checkState
                                            ? FontWeight.w700
                                            : FontWeight.w700,
                                        decoration: value[index].checkState
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                        decorationColor: Colors.white,
                                        decorationThickness: 2,
                                      ),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          textController.text =
              DateFormat('yyyy/MM/dd').format(_selectedDay ?? DateTime.now());
          showModalBottomSheet(
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(25.0))),
            backgroundColor: Colors.white,
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 100,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                            color: Colors.blue,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Transform.translate(
                              offset: const Offset(0, 15),
                              child: const Text(
                                '일일 강의 추가',
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextField(
                                decoration: InputDecoration(hintText: '제목'),
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                '일자',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              TextField(
                                controller: textController,
                                showCursor: false,
                                onTap: () => _selectDate(context),
                              ),
                              const SizedBox(height: 35),
                              ButtonBar(
                                children: <Widget>[
                                  ElevatedButton(
                                    child: const Text('취소'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ElevatedButton(
                                    child: const Text('저장'),
                                    onPressed: () {
                                      kEvents[DateTime(2023, 2, 27)]?.add(Event(
                                          textController.text)); //이러면 안들어간다잉

                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 35,
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ).then((value) => {setState(() {})});
        },
        backgroundColor: Colors.white,
        tooltip: 'ADD EVENT',
        child: const Icon(
          CupertinoIcons.add,
          color: Colors.blue,
        ),
      ),
    );
  }

  Future _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      builder: (BuildContext context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    20.0), // this is the border radius of the picker
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: _selectedDay ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected != null) {
      setState(() {
        _currentDay = selected;
        textController.text = DateFormat('yyyy/MM/dd').format(selected);
      });
    }
  }
}
