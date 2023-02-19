import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univcal/screens/calendar.dart';
import 'package:univcal/screens/timetable.dart';
import 'package:univcal/screens/info.dart';
import 'package:univcal/screens/todo.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  static const List<Tab> myTabs = <Tab>[
    Tab(
      text: '시간표',
      icon: Icon(CupertinoIcons.chart_pie),
    ),
    Tab(
      text: '학습',
      icon: Icon(CupertinoIcons.calendar),
    ),
    Tab(
      text: '복습',
      icon: Icon(CupertinoIcons.text_badge_checkmark),
    ),
    Tab(
      text: '정보',
      icon: Icon(CupertinoIcons.info_circle),
    ),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.05),
          border: Border(
            top: BorderSide(
              color: Colors.black.withOpacity(0.0),
            ),
          ),
        ),
        child: AnimatedTabBar(
          tabs: myTabs,
          controller: _tabController,
        ),
      ),
      body: Container(
        color: Colors.transparent,
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: const [
            MyWidget(),
            CalendarEvents(),
            StudyReminderView(),
            InfoPage(),
          ],
          // myTabs.map((Tab tab) {
          //   return Center(
          //     child: tab.icon,
          //   );
          // }).toList(),
        ),
      ),
    );
  }
}

class AnimatedTabBar extends StatefulWidget {
  const AnimatedTabBar(
      {super.key, required this.tabs, required this.controller});
  final List<Tab> tabs;
  final TabController controller;

  @override
  State<AnimatedTabBar> createState() => _AnimatedTabBar();
}

class _AnimatedTabBar extends State<AnimatedTabBar> {
  final animationDuration = const Duration(milliseconds: 300);
  final animationCurve = Curves.easeInOut;
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      tabIndex = widget.controller.index;
    });
    widget.controller.addListener(() {
      if (widget.controller.indexIsChanging) {
        setState(() {
          tabIndex = widget.controller.index;
        });
      }
    });
  }

  final tabHeight = 80.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: tabHeight,
      child: Stack(
        children: [
          AnimatedAlign(
            duration: animationDuration,
            curve: animationCurve,
            alignment:
                FractionalOffset(1 / (widget.tabs.length - 1) * tabIndex, 0),
            child: Container(
              height: tabHeight,
              color: Colors.transparent,
              child: FractionallySizedBox(
                widthFactor: 1 / widget.tabs.length,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      '${widget.tabs[tabIndex].text}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
              children: widget.tabs.asMap().entries.map((entry) {
            final i = entry.key;
            final tab = entry.value;
            final isActiveTab = i == tabIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => widget.controller.animateTo(i),
                child: Container(
                    color: Colors.transparent,
                    height: tabHeight,
                    child: AnimatedOpacity(
                      duration: animationDuration,
                      opacity: isActiveTab ? 1 : 0.25,
                      child: AnimatedSlide(
                          duration: animationDuration,
                          offset: Offset(0, isActiveTab ? -0.15 : 0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AnimatedOpacity(
                                duration: animationDuration,
                                opacity: isActiveTab ? 1 : 0,
                                child: Transform.translate(
                                  offset: const Offset(8, 0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      color: Colors.blue.withOpacity(0.5),
                                      width: 16,
                                      height: 16,
                                    ),
                                  ),
                                ),
                              ),
                              tab.icon ?? const Icon(CupertinoIcons.home),
                            ],
                          )),
                    )),
              ),
            );
          }).toList()),
        ],
      ),
    );
  }
}
