// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../utils.dart';

class StudyReminderView extends StatefulWidget {
  const StudyReminderView({super.key});

  @override
  State<StudyReminderView> createState() => _StudyReminderViewState();
}

class _StudyReminderViewState extends State<StudyReminderView> {
  List<int> currentReviewDays = [60, 28, 14, 7, 3, 1];
  int currentReviewDaysLength = 6;
  late final ValueNotifier<List<Event>> _selectedEvents;
  final DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

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
    return kEvents[day] ?? [];
  }

  Widget _makeTodoWidget(int dayVariable) {
    dayVariable = dayVariable * -1;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const SizedBox(height: 10),
          _getEventsForDay(_selectedDay!.add(Duration(days: dayVariable)))
                  .isEmpty
              ? const SizedBox(height: 0)
              : Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    '${dayVariable * -1}일전 학습내용',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
          Expanded(
            child: _getEventsForDay(
                        _selectedDay!.add(Duration(days: dayVariable)))
                    .isEmpty
                ? Column(
                    children: [
                      const SizedBox(
                        height: 3,
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                CupertinoIcons.check_mark_circled,
                                color: Colors.blue,
                                size: 100,
                              ),
                              const SizedBox(height: 15),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  '${dayVariable * -1}일전 학습 내용이 없습니다!',
                                  style: const TextStyle(
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
                    ],
                  )
                : ValueListenableBuilder<List<Event>>(
                    valueListenable: ValueNotifier(_getEventsForDay(
                        _selectedDay!.add(Duration(days: dayVariable)))),
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
                              border: Border(bottom: BorderSide(width: 0.3)),
                            ),
                            child: ListTile(
                              trailing: value[index].checkState
                                  ? const Icon(
                                      CupertinoIcons.check_mark_circled_solid,
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
        ],
      ),
    );
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
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '복습',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    DateFormat("MM월 dd일").format(DateTime.now()),
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder: (BuildContext context,
                            StateSetter setState /*You can rename this!*/) {
                          return Container(
                            height: 500, // 모달 높이 크기
                            decoration: const BoxDecoration(
                              color: Colors.white, // 모달 배경색
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50), // 모달 좌상단 라운딩 처리
                                topRight: Radius.circular(50), // 모달 우상단 라운딩 처리
                              ),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 30),
                                const Text(
                                  '복습 일자 지정',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          currentReviewDaysLength =
                                              currentReviewDaysLength - 1;
                                        });
                                      },
                                      icon: const Icon(
                                          CupertinoIcons.minus_circle_fill),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(),
                                      ),
                                      child: Text(
                                        '$currentReviewDaysLength',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 30),
                                      ),
                                    ),
                                    const IconButton(
                                      onPressed: null,
                                      icon: Icon(
                                          CupertinoIcons.add_circled_solid),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ); // 모달 내부 디자인 영역
                        });
                      });
                },
                icon: const Icon(CupertinoIcons.gear_alt_fill),
                iconSize: 35,
                color: Colors.blue.withOpacity(1),
              ),
            ],
          ),
        ),
        Expanded(
          child: DefaultTabController(
            length: 6,
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.blue,
                  constraints: const BoxConstraints.expand(height: 50),
                  child: TabBar(
                      dividerColor: Colors.white,
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                      tabs: [
                        ...List<Tab>.generate(currentReviewDays.length,
                            (index) {
                          return Tab(
                            text: DateFormat("MM월\ndd일").format(DateTime.now()
                                .add(Duration(
                                    days: currentReviewDays[index] * -1))),
                          );
                        })
                      ]),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: TabBarView(children: [
                    ...List<Widget>.generate(currentReviewDays.length,
                        (index) => _makeTodoWidget(currentReviewDays[index])),
                  ]),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
