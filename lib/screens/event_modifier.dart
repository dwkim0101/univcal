import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class EventAddScreen extends StatefulWidget {
  const EventAddScreen({super.key});

  @override
  State<EventAddScreen> createState() => EventAddScreenState();
}

class EventAddScreenState extends State<EventAddScreen> {
  // ignore: prefer_final_fields
  List<bool> _selectedWeekdays = <bool>[
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  final List<Text> dateNameList = [
    const Text('월'),
    const Text('화'),
    const Text('수'),
    const Text('목'),
    const Text('금'),
    const Text('토'),
    const Text('일')
  ];
  final textController = TextEditingController();
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '2023/01/01 ~ 2023/12/31';
  String _rangeCount = '';
  late DateTime _startDay, _endDay;

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

    super.initState();
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
                '강의 추가',
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
              const TextField(
                decoration: InputDecoration(hintText: '제목'),
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
                selectedColor: Colors.black,
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
                    builder: (context) => SfDateRangePicker(
                          onSubmit: (p0) => {
                            textController.text = _range,
                            Navigator.pop(context)
                          },
                          onCancel: () => Navigator.pop(context),
                          navigationMode: DateRangePickerNavigationMode.scroll,
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
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    child: const Text('저장'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
          ),
        )
      ],
    );
  }
}
