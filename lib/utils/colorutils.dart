import 'package:flutter/material.dart';

class ColorUtils {
  static Map<int, Color> skyBlueMap = {
    50: Color.fromRGBO(115, 192, 230, .1),
    100: Color.fromRGBO(115, 192, 230, .2),
    200: Color.fromRGBO(115, 192, 230, .3),
    300: Color.fromRGBO(115, 192, 230, .4),
    400: Color.fromRGBO(115, 192, 230, .5),
    500: Color.fromRGBO(115, 192, 230, .6),
    600: Color.fromRGBO(115, 192, 230, .7),
    700: Color.fromRGBO(115, 192, 230, .8),
    800: Color.fromRGBO(115, 192, 230, .9),
    900: Color.fromRGBO(115, 192, 230, 1),
  };

  static MaterialColor skyBlue = MaterialColor(0xFF73bfe6, skyBlueMap);

    static Map<int, Color> deepBlueMap = {
    50: Color.fromRGBO(62, 85, 119, .1),
    100: Color.fromRGBO(62, 85, 119, .2),
    200: Color.fromRGBO(62, 85, 119, .3),
    300: Color.fromRGBO(62, 85, 119, .4),
    400: Color.fromRGBO(62, 85, 119, .5),
    500: Color.fromRGBO(62, 85, 119, .6),
    600: Color.fromRGBO(62, 85, 119, .7),
    700: Color.fromRGBO(62, 85, 119, .8),
    800: Color.fromRGBO(62, 85, 119, .9),
    900: Color.fromRGBO(62, 85, 119, 1),
  };

  static MaterialColor deepBlue = MaterialColor(0xFF3E5577, deepBlueMap);
}