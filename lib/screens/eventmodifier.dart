import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class eventAddScreen extends StatefulWidget {
  const eventAddScreen({super.key});

  @override
  State<eventAddScreen> createState() => _eventAddScreenState();
}

class _eventAddScreenState extends State<eventAddScreen> {
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
  final GlobalKey _key = GlobalKey();
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
      print(_selectedDate);
      print(_dateCount);
      print(_range);
      print(_rangeCount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '일정 추가',
            style: TextStyle(
                fontSize: 35, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const TextField(
            decoration: InputDecoration(hintText: '제목'),
          ),
          const SizedBox(height: 15),
          // TextButton(
          //   onPressed: () => showBarModalBottomSheet(
          //     // backgroundColor: Colors.transparent,
          //     context: context,
          //     expand: true,
          //     builder: (context) => SfDateRangePicker(
          //       onCancel: () => Navigator.pop(context),
          //       navigationMode: DateRangePickerNavigationMode.scroll,
          //       navigationDirection:
          //           DateRangePickerNavigationDirection.vertical,
          //       onSelectionChanged: _onSelectionChanged,
          //       selectionMode: DateRangePickerSelectionMode.range,
          //       showTodayButton: true,
          //       showActionButtons: true,
          //       enableMultiView: true,
          //     ),
          //   ),
          //   child: const Text('asd'),
          // ),
          const Text(
            '반복 요일',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 5),
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
          const SizedBox(height: 5),
          InputDatePickerFormField(
              firstDate: DateTime(2020), lastDate: DateTime(2023)),
        ],
      ),
    );
  }
}
