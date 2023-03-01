import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:univcal/screens/home.dart';
import 'package:univcal/utils.dart';

void main() async {
  Hive.registerAdapter(RepeatableEventAdapter());
  Hive.registerAdapter(NonRepeatableEventAdapter());
  Hive.registerAdapter(EventAdapter());
  await Hive.initFlutter();
  await Hive.openBox('myBox2');

  // final box = Hive.openBox('mybox');

  runApp(const MyApp());
}

//TODO: LANDINGPAGE / MODIFY EVENT /
//TODO: UPDATE SCREEN ERROR IN CALENDAR ADD + NO EVENTS / ERASE
//TODO: 학.복습 날짜 바꾸어먹기
//TODO: 에타 불러오기 페이지

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UnivCal',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
        // include country code too
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}
