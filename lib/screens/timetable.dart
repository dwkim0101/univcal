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
          color: Colors.grey,
        ),
        // borderRadius: const BorderRadius.all(Radius.circular(5))
      ),
      child: _makeInnerTable(),
    );
  }

  _makeInnerTable() {
    // _timetableEventList[1].add(true);
    int size = 7;
    for (int i = 0; i < _timetableEventList.length; i++) {
      if (size < _timetableEventList[i].length) {
        size = _timetableEventList[i].length;
      }
      print(_timetableEventList[i].length);
    }
    print(size);
    const double firstBoxSize = 20.0;
    const double defaultBoxSize = 50.0;

    return Row(
      children: [
        Column(
          children: [
            const SizedBox(
              //first Container
              width: firstBoxSize,
              height: firstBoxSize,
              // decoration: BoxDecoration(
              //   border: Border.all(
              //     width: 0.5,
              //     color: Colors.green,
              //   ),
              // ),
            ),
            ...List<Widget>.generate(size ~/ 2, (idx) {
              return Container(
                alignment: Alignment.topRight,
                height: defaultBoxSize,
                width: firstBoxSize,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 0.5),
                    bottom: BorderSide(width: 0.5),
                    left: BorderSide(width: 0.5),
                    right: BorderSide(width: 1),
                  ),
                ),
                child: Text(
                  (idx + startTimeValue > 12
                          ? idx + startTimeValue - 12
                          : idx + startTimeValue)
                      .toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }, growable: true)
                .toList(),
          ],
        ),
        ...List<Widget>.generate(5, (dateIndex) {
          return Expanded(
            flex: 1,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: firstBoxSize,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 0.5),
                      bottom: BorderSide(width: 1),
                      left: BorderSide(width: 0.5),
                      right: BorderSide(width: 0.5),
                    ),
                  ),
                  child: Text(
                    dateNameList[dateIndex].toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...List<Widget>.generate(size, (timeIndex) {
                  return Container(
                    height: defaultBoxSize / 2,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _timetableEventList[dateIndex][timeIndex]
                          ? Colors.blue
                          : Colors.transparent,
                      border:
                          _eventBlockBorderConstructor(dateIndex, timeIndex),
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ],
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
                          '2023년 1학기',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '시간표',
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
                        color: Colors.blue.withOpacity(1)),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                _makeTableContainer(),
              ],
            ),
          ),
        ));
  }
}
