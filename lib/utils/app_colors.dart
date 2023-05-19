import 'dart:ui';

import 'package:flutter/material.dart';

const whitee = Color(0xFFffffff);

const mainColor = Color(0xFF3c9091);
const textColorPrimary = Color(0xFF38475B);
final MaterialColor myPrimaryMaterialColor = MaterialColor(
  mainColor.value,
  const <int, Color>{
    50: Color(0xFFe8f3f3),
    100: Color(0xFFc5e2e3),
    200: Color(0xFF9fcfce),
    300: Color(0xFF79bcb9),
    400: Color(0xFF5fa6a3),
    500: mainColor,
    600: Color(0xFF327c7d),
    700: Color(0xFF2c6e6f),
    800: Color(0xFF255f60),
    900: Color(0xFF1a4243),
  },
);
