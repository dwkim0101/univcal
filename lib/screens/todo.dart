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
                  onPressed: null,
                  icon: const Icon(CupertinoIcons.add_circled),
                  iconSize: 35,
                  color: Colors.blue.withOpacity(1)),
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
                      dividerColor: Colors.black,
                      labelStyle: const TextStyle(
                        fontSize: 10,
                      ),
                      tabs: [
                        Tab(
                          text: DateFormat("MM월\ndd일").format(
                              DateTime.now().add(const Duration(days: -60))),
                        ),
                        Tab(
                          text: DateFormat("MM월\ndd일").format(
                              DateTime.now().add(const Duration(days: -28))),
                        ),
                        Tab(
                          text: DateFormat("MM월\ndd일").format(
                              DateTime.now().add(const Duration(days: -14))),
                        ),
                        Tab(
                          text: DateFormat("MM월\ndd일").format(
                              DateTime.now().add(const Duration(days: -7))),
                        ),
                        Tab(
                          text: DateFormat("MM월\ndd일").format(
                              DateTime.now().add(const Duration(days: -3))),
                        ),
                        Tab(
                          text: DateFormat("MM월\ndd일").format(
                              DateTime.now().add(const Duration(days: -1))),
                        ),
                      ]),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: TabBarView(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                              alignment: Alignment.topLeft,
                              child: const Text(
                                '60일전 학습내용',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          Expanded(
                            child: _getEventsForDay(_selectedDay!
                                        .add(const Duration(days: 0)))
                                    .isEmpty
                                ? Container(
                                    alignment: Alignment.topLeft,
                                    child:
                                        const Text('복습할 내용이 없습니다.'), //일정 없을 시
                                  )
                                : ValueListenableBuilder<List<Event>>(
                                    valueListenable: ValueNotifier(
                                        _getEventsForDay(_selectedDay!
                                            .add(const Duration(days: 0)))),
                                    builder: (context, value, _) {
                                      return ListView.builder(
                                        padding: const EdgeInsets.all(0),
                                        itemCount: value.length,
                                        itemBuilder: (context, index) {
                                          return value.isEmpty
                                              ? const Text('asd')
                                              : Container(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 4.0,
                                                  ),
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide()),
                                                  ),
                                                  child: ListTile(
                                                    trailing: const Icon(
                                                        CupertinoIcons.circle),
                                                    onTap: () => print(
                                                        '${value[index]}'),
                                                    title: Text(
                                                      '${value[index]}',
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                    ),
                    Container(
                      child: const Text("Articles Body"),
                    ),
                    Container(
                      child: const Text("User Body"),
                    ),
                    Container(
                      child: const Text("User Body"),
                    ),
                    Container(
                      child: const Text("User Body"),
                    ),
                    Container(
                      child: const Text("User Body"),
                    ),
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
