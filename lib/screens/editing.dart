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
  final box = Hive.box('mybox');

  @override
  void initState() {
    print(dailyEvents);
    super.initState();
  }

  @override
  void dispose() {
    box.put('kEvents', kEvents);
    box.put('repeatingEvents', repeatingEvents);
    box.put('dailyEvents', dailyEvents);
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
                    color: Colors.white,
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
                              '수정 및 삭제',
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
                                        '${DateFormat('yy/MM/dd').format(repeatingEvents[index].startDay)} ~'
                                        ' ${DateFormat('yy/MM/dd').format(repeatingEvents[index].endDay)}'),
                                    onTap: () {},
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
                      ? Container(
                          // decoration: BoxDecoration(border: Border.all()),
                          child: const Center(
                            child: Text(
                              '당일 학습이 존재하지 않습니다',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 0),
                          child: ListView.builder(
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
                                    onTap: () {},
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
