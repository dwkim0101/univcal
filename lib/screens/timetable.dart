import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimeTable extends StatefulWidget {
  const TimeTable({super.key});

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  static int defaultTimeValue = 2 * 7; //30분 단위
  static int startTimeValue = 9; // Starts at 9 o'clock
  final List<String> dateNameList = ['월', '화', '수', '목', '금'];
  // ignore: prefer_final_fields
  List<List<bool>> _timetableEventList = List.generate(
      5, (index) => List.filled(defaultTimeValue, false, growable: true),
      growable: false);
  //0 - 월요일 => 4 - 금요일
  _listUpdate() {
    //TODO: make LIST UPDATE
    _timetableEventList[1][2] = true;
    _timetableEventList[1][1] = true;
    // print(_timetableEventList);
  }

  Border _eventBlockBorderConstructor(int dateIndex, int timeIndex) {
    return const Border(right: BorderSide(width: 1));
    // return Border(bottom: ,top: ,);
  }

  _makeTableContainer() {
    _listUpdate();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue,
        ),
        // borderRadius: const BorderRadius.all(Radius.circular(5))
      ),
      // child: _makeInnerTable(),
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '반복 학습', //TODO: 이름 어떻게 컨트롤할지 생각
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '강의 목록',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: _listUpdate,
                      icon: const Icon(CupertinoIcons.add_circled),
                      iconSize: 35,
                      color: Colors.blue.withOpacity(1),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                _makeTableContainer(),
                const SizedBox(
                  height: 10,
                ),
                Column()
              ],
            ),
          ),
        ));
  }
}
