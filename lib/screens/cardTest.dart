import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> with TickerProviderStateMixin {
  final List<String> dateNameList = ['월', '화', '수', '목', '금', '토', '일'];
  late AnimationController controller;
  late Animation<double> _animation10;
  late Animation<double> _animation11;
  late Animation<double> _animation12;
  late Animation<double> _animation13;

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  void initState() {
    controller = AnimationController(vsync: this);
    _animation10 = Tween(begin: 0.0, end: 1.0).animate(controller);
    _animation11 = Tween(begin: 0.0, end: 1.0).animate(controller);
    _animation12 = Tween(begin: 0.0, end: 1.0).animate(controller);
    _animation13 = Tween(begin: 0.0, end: 1.0).animate(controller);
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
      elevation: 4.0,
      color: Colors.white,
      child: Stack(
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
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  dateNameList[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 42,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(top: 40.0),
                        ),
                        ScaleTransition(
                          scale: _animation10,
                          alignment: FractionalOffset.center,
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(top: 160.0),
                        ),
                        ScaleTransition(
                          scale: _animation11,
                          alignment: FractionalOffset.center,
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(1.0),
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(top: 160.0),
                        ),
                        ScaleTransition(
                          scale: _animation12,
                          alignment: FractionalOffset.center,
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(top: 40.0),
                        ),
                        ScaleTransition(
                          scale: _animation13,
                          alignment: FractionalOffset.center,
                        ),
                      ],
                    ),
                  ]),
              Container(
                padding: const EdgeInsets.all(10.0),
              ),
            ],
          )
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
      body: Container(
        // color: Colors.grey.shade50,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.blue,
                          width: 2.5,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
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
                          // const IconButton(
                          //   onPressed: null,
                          //   icon: Icon(
                          //     CupertinoIcons.add_circled,
                          //     size: 50,
                          //   ),
                          // )
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
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        child: Swiper(
                          outer: true,
                          scale: 0.7,
                          fade: 0.1,
                          itemBuilder: (c, i) {
                            return _buildDynamicCard(i);
                          },
                          pagination: SwiperPagination(
                            builder: DotSwiperPaginationBuilder(
                                color: Colors.grey.shade400),
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(12),
                          ),
                          itemCount: 5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
