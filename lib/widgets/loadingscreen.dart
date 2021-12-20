import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meridian/utils/colorutils.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: ColorUtils.skyBlue,
      child: Center(
        child: Container(
          height: 100,
          width: 100,
          child: Image.file(File('icons/icon.png')),
        ),
      ),
    );
  }
}