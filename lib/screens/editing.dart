import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:univcal/utils.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final box = Hive.box('mybox2');

  @override
  void initState() {
    repeatingEvents.sort(((a, b) => a.startDay.compareTo(b.startDay)));
    dailyEvents.sort(((a, b) => a.date.compareTo(b.date)));
    super.initState();
  }

  @override
  void dispose() {
    box.put('repeatingEvents', repeatingEvents);
    box.put('dailyEvents', dailyEvents);
    box.put('convertedRepeatingEvents', convertedRepeatingEvents);
    super.dispose();
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
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade300,
                        width: 2.5,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '강의 전체 목록',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              '강의 삭제',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  '반복 학습',
                  // style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  flex: 4,
                  child: repeatingEvents.isEmpty
                      ? const Center(
                          child: Text(
                            '반복 학습이 존재하지 않습니다',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 0),
                          child: ListView.builder(
                            // physics: const ScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: repeatingEvents.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(0),
                                child: Container(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 10),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                      width: 1,
                                      color: Colors.grey.shade400,
                                    )),
                                  ),
                                  child: ListTile(
                                    title: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 3.0),
                                      child: Text(
                                        repeatingEvents[index].title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    subtitle: Text(
                                        '[${makeWeekDaysString(repeatingEvents[index].repeatWeekdays)}]'
                                        '\n${DateFormat('yy/MM/dd').format(repeatingEvents[index].startDay)} ~'
                                        ' ${DateFormat('yy/MM/dd').format(repeatingEvents[index].endDay)}'),
                                    onTap: () {
                                      flutterDialog(context, true, index);
                                      setState(() {});
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text('당일 학습'),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  flex: 4,
                  child: dailyEvents.isEmpty
                      ? const Center(
                          child: Text(
                            '당일 학습이 존재하지 않습니다',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 0),
                          child: ListView.builder(
                            padding: const EdgeInsets.only(top: 5, bottom: 10),
                            key: ValueKey(dailyEvents.length),
                            // physics: const ScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: dailyEvents.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(0),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                      width: 1,
                                      color: Colors.grey.shade400,
                                    )),
                                  ),
                                  child: ListTile(
                                    title: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 3.0),
                                      child: Text(
                                        dailyEvents[index].title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    subtitle: Text(DateFormat('yyyy/MM/dd')
                                        .format(dailyEvents[index].date)),
                                    onTap: () {
                                      setState(() {
                                        flutterDialog(context, false, index);
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void flutterDialog(BuildContext context, bool isRepeatAble, int index) {
  showDialog(
      context: context,
      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          //Dialog Main Title
          title: Column(
            children: const <Widget>[
              Text("정말로 삭제하시겠습니까?"),
            ],
          ),
          //
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ButtonBar(
                children: [
                  ElevatedButton(
                    child: const Text("취소"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    child: const Text("확인"),
                    onPressed: () {
                      if (isRepeatAble) {
                        for (var i = 0;
                            i < convertedRepeatingEvents.length;
                            i++) {
                          if (repeatingEvents[index].index ==
                              convertedRepeatingEvents[i].parentIndex) {
                            convertedRepeatingEvents.removeAt(i);
                            i--;
                          }
                        }
                        repeatingEvents.removeAt(index);
                      } else {
                        dailyEvents.removeAt(index);
                      }
                      kEventUpdate();
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            ],
          ),
        );
      });
}
