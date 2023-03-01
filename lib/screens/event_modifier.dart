import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:univcal/utils.dart';

class EventAddScreen extends StatefulWidget {
  const EventAddScreen({super.key});

  @override
  State<EventAddScreen> createState() => EventAddScreenState();
}

class EventAddScreenState extends State<EventAddScreen> {
  final box = Hive.box('mybox2');
  // ignore: prefer_final_fields
  List<bool> _selectedWeekdays = List.filled(7, false);
  bool validateTitle = false;
  final List<Text> dateNameList = [
    const Text('월'),
    const Text('화'),
    const Text('수'),
    const Text('목'),
    const Text('금'),
    const Text('토'),
    const Text('일')
  ];
  final titleTextController = TextEditingController();
  final textController = TextEditingController();
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '2023/01/01 ~ 2023/12/31';
  String _rangeCount = '';
  DateTime _startDay = DateTime(2023, 01, 01), _endDay = DateTime(2023, 12, 31);

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('yyyy/MM/dd').format(args.value.startDate)} ~'
            ' ${DateFormat('yyyy/MM/dd').format(args.value.endDate ?? args.value.startDate)}';
        _startDay = args.value.startDate;
        _endDay = args.value.endDate ?? args.value.startDate;
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  @override
  void initState() {
    textController.text = _range;
    // for (RepeatableEvent _ in repeatingEvents) {
    //   _.printNewClass();
    // }
    super.initState();
  }

  @override
  void dispose() {
    box.put('repeatingEvents', repeatingEvents);
    box.put('dailyEvents', dailyEvents);
    box.put('convertedRepeatingEvents', convertedRepeatingEvents);
    box.put('currentParentIndex', currentParentIndex);
    // for (RepeatableEvent _ in repeatingEvents) {
    //   _.printNewClass();
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Transform.translate(
              offset: const Offset(0, 25),
              child: const Text(
                '반복 강의 추가',
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleTextController,
                decoration: InputDecoration(
                  hintText: '제목',
                  errorText: validateTitle ? '값 입력' : null,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                '반복',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              ToggleButtons(
                direction: Axis.horizontal,
                onPressed: (int index) {
                  // All buttons are selectable.
                  setState(() {
                    _selectedWeekdays[index] = !_selectedWeekdays[index];
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                // selectedBorderColor: Colors.green[700],
                // selectedColor: Colors.grey,
                // selectedBorderColor: Colors.blue,
                // fillColor: Colors.blue,
                // color: Colors.blue,
                isSelected: _selectedWeekdays,
                children: <Widget>[...dateNameList],
              ),
              const SizedBox(height: 15),
              const Text(
                '기간',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                readOnly: true,
                showCursor: false,
                onTap: () => showBarModalBottomSheet(
                    // backgroundColor: Colors.transparent,
                    context: context,
                    expand: true,
                    builder: (context) => Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SfDateRangePicker(
                            onSubmit: (p0) => {
                              textController.text = _range,
                              Navigator.pop(context)
                            },
                            onCancel: () => Navigator.pop(context),
                            navigationMode:
                                DateRangePickerNavigationMode.scroll,
                            navigationDirection:
                                DateRangePickerNavigationDirection.vertical,
                            onSelectionChanged: _onSelectionChanged,
                            selectionMode:
                                DateRangePickerSelectionMode.extendableRange,
                            showTodayButton: true,
                            showActionButtons: true,
                            enableMultiView: true,
                            cancelText: '취소',
                            confirmText: '선택',
                          ),
                        )),
                controller: textController,
                enabled: true,
                selectionWidthStyle: BoxWidthStyle.max,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  // labelText: '2023/04/03 ~ 2023/04/06',
                ),
              ),
              ButtonBar(
                children: <Widget>[
                  ElevatedButton(
                    child: const Text('취소'),
                    onPressed: () {
                      isAdded = false;
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    child: const Text('저장'),
                    onPressed: () {
                      setState(() {
                        if (titleTextController.text.isEmpty) {
                          validateTitle = true;
                          isAdded = false;
                        } else {
                          validateTitle = false;

                          repeatingEvents.add(RepeatableEvent(
                            index: currentParentIndex,
                            title: titleTextController.text,
                            startDay: _startDay,
                            endDay: _endDay,
                            repeatWeekdays: _selectedWeekdays,
                          ));
                          isAdded = true;
                          currentParentIndex++;
                          box.put('currentParentIndex', currentParentIndex);
                          box.put('repeatingEvents', repeatingEvents);
                          box.put('dailyEvents', dailyEvents);
                          box.put('convertedRepeatingEvents',
                              convertedRepeatingEvents);
                          Navigator.pop(context);
                        }
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        // Container(
        //   decoration: BoxDecoration(
        //     border: Border.all(
        //       color: Colors.grey,
        //     ),
        //   ),
        // )
      ],
    );
  }
}
