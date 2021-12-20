import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MiscUtils {

  static String convertLocToString(LatLng loc) {
    String res = loc.latitude.toString() + "|" + loc.longitude.toString();

    return res;
  }

  static LatLng convertStringToLoc(String str) {
    LatLng res = LatLng(double.parse(str.split("|")[0]), double.parse(str.split("|")[1]));

    return res;
  }

}