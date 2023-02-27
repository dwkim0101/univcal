import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:univcal/screens/event_modifier.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> with TickerProviderStateMixin {
  final List<String> dateNameList = ['월', '화', '수', '목', '금', '토', '일'];
  final List<String> dateNameListEng = [
    'MON',
    'TUE',
    'WED',
    'THUR',
    'FRI',
    'SAT',
    'SUN'
  ];
  late AnimationController controller;
  final GlobalKey _paginationKey = GlobalKey();
  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  void initState() {
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
                        ),
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
                child: ListView.builder(
                  physics: const ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(0),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                            width: 1,
                            color: Colors.grey.shade400,
                          )),
                        ),
                        child: ListTile(
                          title: const Padding(
                            padding: EdgeInsets.only(bottom: 3.0),
                            child: Text(
                              "TEST",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          subtitle: const Text('23/03/02~23/06/30'),
                          trailing: const Icon(
                            CupertinoIcons.circle,
                            // color: Colors.blue,
                          ),
                          onTap: () {},
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
                      itemCount: 5,
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
