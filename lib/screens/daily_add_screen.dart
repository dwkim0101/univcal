import 'package:flutter/material.dart';

class DailyEventAddScreen extends StatefulWidget {
  const DailyEventAddScreen({super.key});

  @override
  State<DailyEventAddScreen> createState() => DailyEventAddScreenState();
}

class DailyEventAddScreenState extends State<DailyEventAddScreen> {
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

  // @override
  @override
  void initState() {
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
                showCursor: false,
                onTap: () => showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
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
