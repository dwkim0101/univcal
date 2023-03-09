import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:univcal/screens/home.dart';
import 'package:univcal/utils.dart';
import 'size_config.dart';
import 'onboarding_contents.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final box = Hive.box('mybox2');
  var currentReviewDays = [];

  List<TextEditingController> text = [];
  List<bool> validate = List.filled(6, false, growable: true);
  int trueLength = 0;
  late PageController _controller;

  @override
  void initState() {
    for (int i = 0; i < 6; i++) {
      text.add(TextEditingController());
    }
    currentReviewDays =
        box.get('currentReviewDays', defaultValue: [60, 28, 7, 5, 3, 1]);
    _controller = PageController();
    super.initState();
  }

  double currentOpacity = 0;
  int _currentPage = 0;
  List colors = const [
    Color(0xffDAD3C8),
    Color(0xffFFE5DE),
    Color(0xffDCF6E6),
  ];

  AnimatedContainer _buildDots({
    int? index,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: Color(0xFF000000),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  bool opacityController() {
    if (contents.length == _currentPage + 1) {
      setState(() {
        currentOpacity = 1;
      });
      return true;
    } else {
      setState(() {
        currentOpacity = 0;
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;
    double height = SizeConfig.screenH!;

    return Scaffold(
      backgroundColor: colors[_currentPage],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _controller,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: contents.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        Image.asset(
                          contents[i].image,
                          height: SizeConfig.blockV! * 35,
                        ),
                        SizedBox(
                          height: (height >= 840) ? 60 : 30,
                        ),
                        Text(
                          contents[i].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: (width <= 550) ? 30 : 30,
                          ),
                        ),
                        contents[i].desc == null
                            ? Container()
                            : const SizedBox(height: 15),
                        contents[i].desc == null
                            ? Container()
                            : Text(
                                contents[i].desc,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: (width <= 550) ? 17 : 25,
                                ),
                                textAlign: TextAlign.center,
                              ),
                        _currentPage == 1
                            ? ElevatedButton(
                                onPressed: () {
                                  int currentReviewDaysLength =
                                      currentReviewDays.length;
                                  for (int i = 0;
                                      i < currentReviewDaysLength;
                                      i++) {
                                    validate[i] = false;
                                  }
                                  showModalBottomSheet(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(35.0))),
                                      backgroundColor: Colors.white,
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter setState) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                // const SizedBox(height: 30),
                                                Column(
                                                  children: [
                                                    const SizedBox(height: 20),
                                                    const Text(
                                                      '복습 일자 지정',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 25),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    const Text(
                                                      '복습 일자를 지정해주세요. 복습은 1 ~ 6 회를 지원합니다.',
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        IconButton(
                                                          splashRadius: 25,
                                                          color: Colors.black,
                                                          onPressed:
                                                              currentReviewDaysLength >=
                                                                      2
                                                                  ? () {
                                                                      setState(
                                                                          () {
                                                                        currentReviewDaysLength =
                                                                            currentReviewDaysLength -
                                                                                1;
                                                                      });
                                                                    }
                                                                  : null,
                                                          icon: const Icon(
                                                              CupertinoIcons
                                                                  .minus_circle_fill),
                                                        ),
                                                        Container(
                                                          height: 40,
                                                          width: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          child: Text(
                                                            '$currentReviewDaysLength',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        30,
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                        ),
                                                        IconButton(
                                                          splashRadius: 25,
                                                          color: Colors.black,
                                                          onPressed:
                                                              currentReviewDaysLength <=
                                                                      5
                                                                  ? () {
                                                                      setState(
                                                                          () {
                                                                        currentReviewDaysLength =
                                                                            currentReviewDaysLength +
                                                                                1;
                                                                      });
                                                                    }
                                                                  : null,
                                                          icon: const Icon(
                                                              CupertinoIcons
                                                                  .add_circled_solid),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            ...List<
                                                                Widget>.generate(
                                                              currentReviewDaysLength,
                                                              (index) {
                                                                return Column(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 50,
                                                                      height:
                                                                          50,
                                                                      child:
                                                                          TextField(
                                                                        controller:
                                                                            text[index],
                                                                        keyboardType:
                                                                            TextInputType.number,
                                                                        inputFormatters: <
                                                                            TextInputFormatter>[
                                                                          FilteringTextInputFormatter
                                                                              .digitsOnly
                                                                        ], // Only numbers can be entered
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          errorText: validate[index]
                                                                              ? '값 입력'
                                                                              : null,
                                                                          hintText: (currentReviewDays.length - 1 < index)
                                                                              ? '0'
                                                                              : currentReviewDays[index].toString(),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Text(
                                                                      '${index + 1}회차',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 40,
                                                    ),
                                                    ElevatedButton(
                                                      style: const ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStatePropertyAll(
                                                                  Colors
                                                                      .black)),
                                                      onPressed: () {
                                                        setState(() {
                                                          trueLength = 0;
                                                          for (int i = 0;
                                                              i < currentReviewDaysLength;
                                                              i++) {
                                                            if (text[i]
                                                                .text
                                                                .isEmpty) {
                                                              validate[i] =
                                                                  true;
                                                            } else {
                                                              validate[i] =
                                                                  false;
                                                              trueLength += 1;
                                                            }
                                                          }
                                                          if (currentReviewDaysLength ==
                                                              trueLength) {
                                                            currentReviewDays =
                                                                [];
                                                            for (int i = 0;
                                                                i < currentReviewDaysLength;
                                                                i++) {
                                                              currentReviewDays
                                                                  .add(int.parse(
                                                                      text[i]
                                                                          .text));
                                                              currentReviewDays
                                                                  .sort((b,
                                                                          a) =>
                                                                      a.compareTo(
                                                                          b));
                                                            }
                                                            text = [];
                                                            for (int i = 0;
                                                                i < 6;
                                                                i++) {
                                                              text.add(
                                                                  TextEditingController());
                                                            }
                                                            validate =
                                                                List.filled(
                                                                    6, false);
                                                            super.setState(() {
                                                              box.put(
                                                                  'currentReviewDays',
                                                                  currentReviewDays);
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          }
                                                        });
                                                      },
                                                      child: const Text('저장'),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 50,
                                                )
                                              ],
                                            ),
                                          ); // 모달 내부 디자인 영역
                                        });
                                      });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                  padding: (width <= 550)
                                      ? const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 20)
                                      : const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 25),
                                  textStyle: TextStyle(
                                      fontSize: (width <= 550) ? 13 : 17),
                                ),
                                child: const Text("복습일자 지정하기"),
                              )
                            : Container(),
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      contents.length,
                      (int index) => _buildDots(
                        index: index,
                      ),
                    ),
                  ),
                  opacityController()
                      ? AnimatedOpacity(
                          opacity: currentOpacity,
                          duration: const Duration(milliseconds: 3000),
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: ElevatedButton(
                              onPressed: () {
                                isFirstLoading = true;
                                box.put('isFirstLoading', isFirstLoading);
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      maintainState: false,
                                      builder: (context) => const Home()),
                                );
                                // WillPopScope( //TODO: 아직 이상해
                                //     child: const Home(),
                                //     onWillPop: () async => false);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: (width <= 550)
                                    ? const EdgeInsets.symmetric(
                                        horizontal: 100, vertical: 20)
                                    : EdgeInsets.symmetric(
                                        horizontal: width * 0.2, vertical: 25),
                                textStyle: TextStyle(
                                    fontSize: (width <= 550) ? 13 : 17),
                              ),
                              child: const Text("시작하기"),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  _controller.jumpToPage(2);
                                },
                                style: TextButton.styleFrom(
                                  elevation: 0,
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: (width <= 550) ? 13 : 17,
                                  ),
                                ),
                                child: const Text(
                                  "넘기기",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _controller.nextPage(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  elevation: 0,
                                  padding: (width <= 550)
                                      ? const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 20)
                                      : const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 25),
                                  textStyle: TextStyle(
                                      fontSize: (width <= 550) ? 13 : 17),
                                ),
                                child: const Text("다음"),
                              ),
                            ],
                          ),
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
