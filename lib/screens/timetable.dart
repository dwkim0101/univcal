import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:univcal/screens/event_modifier.dart';
import 'package:univcal/utils.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> with TickerProviderStateMixin {
  final box = Hive.box('mybox2');
  int currentLength = 0;
  List<int> repeatingEventsNumberList = List.generate(7, (_) => 0);
  List<List<String>> repeatingEventsTitleList = List.generate(7, (_) => []);
  List<List<String>> repeatingEventsWeekDaysList = List.generate(7, (_) => []);
  List<List<DateTime>> repeatingEventsStartDaysList =
      List.generate(7, (_) => []);
  List<List<DateTime>> repeatingEventsEndDaysList = List.generate(7, (_) => []);

  late AnimationController controller;
  final GlobalKey _paginationKey = GlobalKey();
  @override
  void dispose() {
    controller.dispose();
    box.put('repeatingEvents', repeatingEvents);
    box.put('dailyEvents', dailyEvents);
    box.put('convertedRepeatingEvents', convertedRepeatingEvents);
    box.put('currentParentIndex', currentParentIndex);
    super.dispose();
  }

  @override
  void initState() {
    print(isFirstLoading);
    // print(DateTime.now().weekday);
    // box.delete('kEvents');
    // box.delete('convertedRepeatingEvents');
    // box.delete('repeatingEvents');
    // box.delete('dailyEvents');
    // repeatingEvents = [];
    // convertedRepeatingEvents = [];
    // dailyEvents = [];
    // repeatingEvents = box.get('repeatingEvents',
    //     defaultValue: <RepeatableEvent>[]).cast<RepeatableEvent>();
    // dailyEvents = box.get('dailyEvents',
    //     defaultValue: <NonRepeatableEvent>[]).cast<NonRepeatableEvent>();

    kEventUpdate();
    for (RepeatableEvent _ in repeatingEvents) {
      for (int i = 0; i < 7; i++) {
        if (_.repeatWeekdays[i]) {
          // &&
          // getHashCode(_.startDay) <= getHashCode(DateTime.now()) &&
          // getHashCode(DateTime.now()) <= getHashCode(_.endDay)
          repeatingEventsNumberList[i]++; //사실 필요 없긴 한데
          repeatingEventsTitleList[i].add(_.title);
          repeatingEventsWeekDaysList[i]
              .add(makeWeekDaysString(_.repeatWeekdays));
          repeatingEventsStartDaysList[i].add(_.startDay);
          repeatingEventsEndDaysList[i].add(_.endDay);
        }
      }
    }
    int currentLength = repeatingEvents.length;
    controller = AnimationController(vsync: this);
    controller.animateTo(1.0, duration: const Duration(seconds: 3));
    super.initState();
  }

  Widget _buildDynamicCard(int index) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey.shade300,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(25),
        //set border radius more than 50% of height and width to make circle
      ),
      elevation: 2.0,
      color: Colors.white,
      child: Column(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  color: Colors.blue,
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          dateNameList[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          dateNameListEng[index],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    Transform.translate(
                      offset: const Offset(12, 0),
                      child: IconButton(
                        onPressed: () => showBarModalBottomSheet(
                          context: context,
                          expand: true,
                          builder: (context) => const EventAddScreen(),
                        ).then((value) => {
                              setState(() {
                                if (isAdded) {
                                  var _ = repeatingEvents[
                                      repeatingEvents.length - 1];
                                  for (int i = 0; i < 7; i++) {
                                    if (_.repeatWeekdays[i]) {
                                      repeatingEventsNumberList[
                                          i]++; //사실 필요 없긴 한데
                                      repeatingEventsTitleList[i].add(_.title);

                                      repeatingEventsWeekDaysList[i].add(
                                          makeWeekDaysString(_.repeatWeekdays));
                                      repeatingEventsStartDaysList[i]
                                          .add(_.startDay);
                                      repeatingEventsEndDaysList[i]
                                          .add(_.endDay);
                                    }
                                  }
                                  for (DateTime currentDay
                                      in daysInRange(_.startDay, _.endDay)) {
                                    if (_.repeatWeekdays[
                                        currentDay.weekday - 1]) {
                                      int tempIndex =
                                          convertedRepeatingEvents.length;
                                      convertedRepeatingEvents
                                          .add(NonRepeatableEvent(
                                        title: _.title,
                                        date: currentDay,
                                        index: tempIndex,
                                        parentIndex: _.index,
                                      ));
                                    }
                                  }
                                  kEventUpdate();
                                  isAdded = false;
                                }
                              })
                            }),
                        icon: const Icon(
                          CupertinoIcons.add_circled,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              width: double.maxFinite,
              decoration: const BoxDecoration(
                // border: Border.all(width: 4),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25), // 리스트 박스 넘지마세요
                ),
              ),
              child: SizedBox.expand(
                child: repeatingEventsNumberList[index] == 0
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.rays,
                              color: Colors.grey.shade600,
                              size: 60,
                            ),
                            const SizedBox(height: 10),
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                '학습 할 내용이 없습니다',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ), //일정 없을 시
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        key: ValueKey(repeatingEvents.length),
                        physics: const ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: repeatingEventsNumberList[index],
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: const EdgeInsets.all(0),
                            child: Container(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 15),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                  width: 1,
                                  color: Colors.grey.shade400,
                                )),
                              ),
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(bottom: 3.0),
                                  child: Text(
                                    repeatingEventsTitleList[index][i],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                subtitle: Text(
                                    '[${repeatingEventsWeekDaysList[index][i]}]'
                                    '\n${DateFormat('yy/MM/dd').format(repeatingEventsStartDaysList[index][i])} ~'
                                    ' ${DateFormat('yy/MM/dd').format(repeatingEventsEndDaysList[index][i])}'),
                                // trailing: const Icon(
                                //   CupertinoIcons.circle,
                                //   // color: Colors.blue,
                                // ),
                                // onTap: () {
                                //   //TODO:ONTAP GUHYUN
                                // },
                              ),
                            ),
                          );
                        },
                      ),
              ),
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
          backgroundColor: Colors.white,
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
                              '반복 학습',
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
                              '강의 목록',
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
                  height: 5,
                ),
                Expanded(
                  flex: 8,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Swiper(
                      index: DateTime.now().weekday - 1, //TODO:
                      key: ValueKey(repeatingEvents.length),
                      outer: true,
                      scale: 0.7,
                      fade: 0.1,
                      itemBuilder: (c, i) {
                        return _buildDynamicCard(i);
                      },
                      pagination: SwiperPagination(
                        key: _paginationKey,
                        builder: DotSwiperPaginationBuilder(
                            color: Colors.grey.shade400),
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(12),
                      ),
                      itemCount: 7,
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
