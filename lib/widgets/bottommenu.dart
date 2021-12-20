import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:meridian/utils/colorutils.dart';
import 'geocircle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BottomMenu extends StatelessWidget {
  final Completer<GoogleMapController> mapController;
  final bool isOpen;

  const BottomMenu(
      {Key? key, required this.mapController, required this.isOpen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
