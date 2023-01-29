import 'package:flutter/material.dart';
import 'package:univcal/screens/home.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('ko-KR').then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UnivCal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}
