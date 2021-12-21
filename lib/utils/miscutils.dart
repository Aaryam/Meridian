import 'dart:math';

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

  static String generateRandomID(int length) {
    List<String> charList = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z".split(",");
    String finalValue = "";

    Random rand = new Random();

    for (int i = 0; i < length; i++) {
      var char = rand.nextBool() ? charList[rand.nextInt(charList.length - 1)] : charList[rand.nextInt(charList.length - 1)].toUpperCase();
      finalValue += char;
    }

    return finalValue;
  }

  static double findDistance(LatLng initialPos, LatLng finalPos) {
    double xDistance = (initialPos.latitude - finalPos.latitude).abs();
    double yDistance = (initialPos.latitude - finalPos.latitude).abs();

    return xDistance + yDistance;
  }

  static double convertLatToKM(double d) {
    return (d * 111000) / 1000;
  }

}