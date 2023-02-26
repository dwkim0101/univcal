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

class _StudyReminderViewState extends State<StudyReminderView>
    with TickerProviderStateMixin {
  List<int> currentReviewDays = [60, 28, 14, 7, 3, 1];
  List<TextEditingController> _text = [];
  List<bool> _validate = List.filled(6, false, growable: true);
  int _trueLength = 0;

  late final ValueNotifier<List<Event>> _selectedEvents;
  final DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < currentReviewDays.length; i++) {
      _text.add(TextEditingController());
    }
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
                    '${dayVariable * -1}일 전',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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
                                CupertinoIcons.rays,
                                color: Colors.grey,
                                size: 60,
                              ),
                              const SizedBox(height: 15),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  '${dayVariable * -1}일 전 학습내용이 없습니다',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
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
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        itemCount: value.length,
                        physics: const ScrollPhysics(),
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
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
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
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
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
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Transform.translate(
                offset: const Offset(0, -5),
                child: IconButton(
                  onPressed: () {
                    int currentReviewDaysLength = currentReviewDays.length;
                    for (int i = 0; i < currentReviewDaysLength; i++) {
                      _validate[i] = false;
                    }
                    showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0))),
                        backgroundColor: Colors.white,
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // const SizedBox(height: 30),
                                  Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      const Text(
                                        '복습 일자 지정',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        '복습 일자를 지정해주세요. 복습은 1 ~ 6 회를 지원합니다.',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            splashRadius: 25,
                                            color: Colors.blue,
                                            onPressed:
                                                currentReviewDaysLength >= 2
                                                    ? () {
                                                        setState(() {
                                                          currentReviewDaysLength =
                                                              currentReviewDaysLength -
                                                                  1;
                                                        });
                                                      }
                                                    : null,
                                            icon: const Icon(CupertinoIcons
                                                .minus_circle_fill),
                                          ),
                                          Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.white),
                                            ),
                                            child: Text(
                                              '$currentReviewDaysLength',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.blue),
                                            ),
                                          ),
                                          IconButton(
                                            splashRadius: 25,
                                            color: Colors.blue,
                                            onPressed:
                                                currentReviewDaysLength <= 5
                                                    ? () {
                                                        setState(() {
                                                          currentReviewDaysLength =
                                                              currentReviewDaysLength +
                                                                  1;
                                                        });
                                                      }
                                                    : null,
                                            icon: const Icon(CupertinoIcons
                                                .add_circled_solid),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ...List<Widget>.generate(
                                                currentReviewDaysLength,
                                                (index) {
                                                  return Column(
                                                    children: [
                                                      SizedBox(
                                                        width: 50,
                                                        height: 50,
                                                        child: TextField(
                                                          controller:
                                                              _text[index],
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          inputFormatters: <
                                                              TextInputFormatter>[
                                                            FilteringTextInputFormatter
                                                                .digitsOnly
                                                          ], // Only numbers can be entered
                                                          textAlign:
                                                              TextAlign.center,
                                                          decoration:
                                                              InputDecoration(
                                                            errorText:
                                                                _validate[index]
                                                                    ? '값 입력'
                                                                    : null,
                                                            hintText: (currentReviewDays
                                                                            .length -
                                                                        1 <
                                                                    index)
                                                                ? '0'
                                                                : currentReviewDays[
                                                                        index]
                                                                    .toString(),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        '${index + 1}회차',
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      ElevatedButton(
                                        child: const Text('저장'),
                                        onPressed: () {
                                          setState(() {
                                            _trueLength = 0;
                                            for (int i = 0;
                                                i < currentReviewDaysLength;
                                                i++) {
                                              if (_text[i].text.isEmpty) {
                                                _validate[i] = true;
                                              } else {
                                                _validate[i] = false;
                                                _trueLength += 1;
                                              }
                                            }
                                            if (currentReviewDaysLength ==
                                                _trueLength) {
                                              currentReviewDays = [];
                                              for (int i = 0;
                                                  i < currentReviewDaysLength;
                                                  i++) {
                                                currentReviewDays.add(
                                                    int.parse(_text[i].text));
                                              }
                                              _text = [];
                                              for (int i = 0; i < 6; i++) {
                                                _text.add(
                                                    TextEditingController());
                                              }
                                              _validate = List.filled(6, false);
                                              super.setState(() {
                                                Navigator.pop(context);
                                              });
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  )
                                ],
                              ),
                            ); // 모달 내부 디자인 영역
                          });
                        });
                  },
                  icon: const Icon(CupertinoIcons.gear_alt_fill),
                  iconSize: 30,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: DefaultTabController(
            length: currentReviewDays.length,
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.blue,
                  constraints: const BoxConstraints.expand(height: 50),
                  child: TabBar(
                      // controller: _tabController,
                      dividerColor: Colors.white,
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
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
