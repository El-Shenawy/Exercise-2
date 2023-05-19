import 'package:exercise_2/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/screens/exchange_rate_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Exchange Rates',
      theme: ThemeData(
        primarySwatch: myPrimaryMaterialColor,
      ),
      debugShowCheckedModeBanner: false,
      home: ExchangeRatePage(),
    );
  }
}
