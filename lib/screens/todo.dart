// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../utils.dart';

class StudyReminderView extends StatefulWidget {
  const StudyReminderView({super.key});
  @override
  State<StudyReminderView> createState() => _StudyReminderViewState();
}

class _StudyReminderViewState extends State<StudyReminderView> {
  final box = Hive.box('mybox2');
  List<int> currentReviewDays = [];
  List<TextEditingController> text = [];
  List<bool> validate = List.filled(6, false, growable: true);
  int trueLength = 0;

  late final ValueNotifier<List<Event>> selectedEvents;
  final DateTime focusedDay = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime? selectedDay;

  @override
  void initState() {
    super.initState();

    currentReviewDays =
        box.get('currentReviewDays', defaultValue: [60, 28, 7, 5, 3, 1]);
    // if (currentReviewDays.isEmpty) {
    //   currentReviewDays = [60, 28, 7, 5, 3, 1];
    // }
    // print(currentReviewDays);
    for (int i = 0; i < 6; i++) {
      text.add(TextEditingController());
    }

    selectedDay = focusedDay;
    selectedEvents = ValueNotifier(_getEventsForDay(selectedDay!));
  }

  @override
  void dispose() {
    selectedEvents.dispose();
    // box.put('kEvents', kEvents);
    box.put('currentReviewDays', currentReviewDays);
    box.put('repeatingEvents', repeatingEvents);
    box.put('dailyEvents', dailyEvents);
    box.put('convertedRepeatingEvents', convertedRepeatingEvents);
    // print('disposed!');
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
          _getEventsForDay(selectedDay!.add(Duration(days: dayVariable)))
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
                        selectedDay!.add(Duration(days: dayVariable)))
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
                        selectedDay!.add(Duration(days: dayVariable)))),
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
                              trailing: eventHandler(value, index,
                                      value[index].repeatable) //TODO:
                                  ? const Icon(
                                      CupertinoIcons.check_mark_circled_solid,
                                      color: Colors.blue,
                                    )
                                  : const Icon(CupertinoIcons.circle),
                              onTap: () => {
                                setState(() {
                                  DateTime temp = DateTime.utc(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day);
                                  int currentIndex = value[index].index;
                                  value[index].reviewState[temp] =
                                      !(value[index].reviewState[temp]!);
                                  //TODO: 왜 되는지 모르겠지만 일단 됨...?

                                  // if (value[index].repeatable) {
                                  //   convertedRepeatingEvents[currentIndex]
                                  //           .reviewState[temp] =
                                  //       !convertedRepeatingEvents[currentIndex]
                                  //           .reviewState[temp]!;
                                  // } else {
                                  //   dailyEvents[currentIndex]
                                  //           .reviewState[temp] =
                                  //       !dailyEvents[currentIndex]
                                  //           .reviewState[temp]!;
                                  // }
                                })
                              },
                              title: Text(
                                '${value[index]}',
                                style: TextStyle(
                                    color: eventHandler(value, index,
                                            value[index].repeatable)
                                        ? Colors.grey
                                        : Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    decoration: eventHandler(value, index,
                                            value[index].repeatable)
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
                      validate[i] = false;
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
                                                              text[index],
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
                                                                validate[index]
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
                                            trueLength = 0;
                                            for (int i = 0;
                                                i < currentReviewDaysLength;
                                                i++) {
                                              if (text[i].text.isEmpty) {
                                                validate[i] = true;
                                              } else {
                                                validate[i] = false;
                                                trueLength += 1;
                                              }
                                            }
                                            if (currentReviewDaysLength ==
                                                trueLength) {
                                              currentReviewDays = [];
                                              for (int i = 0;
                                                  i < currentReviewDaysLength;
                                                  i++) {
                                                currentReviewDays.add(
                                                    int.parse(text[i].text));
                                                currentReviewDays.sort(
                                                    (b, a) => a.compareTo(b));
                                              }
                                              text = [];
                                              for (int i = 0; i < 6; i++) {
                                                text.add(
                                                    TextEditingController());
                                              }
                                              validate = List.filled(6, false);
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

bool eventHandler(List<Event> value, int index, bool isRepeatable) {
  // print(value);
  DateTime temp = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  int currentIndex = value[index].index;
  if (isRepeatable) {
    if (convertedRepeatingEvents[currentIndex].reviewState[temp] == null) {
      convertedRepeatingEvents[currentIndex].reviewState.addAll({temp: false});
    }
    return convertedRepeatingEvents[currentIndex].reviewState[temp]!;
  } else {
    if (dailyEvents[currentIndex].reviewState[temp] == null) {
      dailyEvents[currentIndex].reviewState.addAll({temp: false});
    }
    return dailyEvents[currentIndex].reviewState[temp]!;
  }
}
