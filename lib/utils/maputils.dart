import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meridian/utils/databaseutils.dart';

import 'miscutils.dart';

class MapUtils {
  static Future<LatLng> getLoc() async {
    LocationData loc = await Location().getLocation();

    return LatLng(loc.latitude as double, loc.longitude as double);
  }

  static CameraPosition locToCameraPos(loc, zoom) {
    return CameraPosition(target: loc, zoom: zoom);
  }

  static Future<void> animateLoc(
      Completer<GoogleMapController> mapController, LatLng loc) async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(locToCameraPos(loc, 20.0)));
  }

  static Future<Map<MarkerId, Marker>> getMarkers() async {    
    Map<MarkerId, Marker> finalValue = Map<MarkerId, Marker>();
    List<String> following = await DatabaseUtils.getFollowingList(
        FirebaseAuth.instance.currentUser!.email as String);

    for (int i = 0; i < following.length; i++) {
      var f = following[i];
      String status = await DatabaseUtils.getStatus(f);
      String distance = MiscUtils.convertLatToKM(await DatabaseUtils.getDistance(f)).round().toString();
      String statusText = '$status - $distance ' 'km';

      MarkerId markerId = MarkerId(MiscUtils.generateRandomID(10));
      BitmapDescriptor icon;

      if (await DatabaseUtils.isParty(f)) {
        icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose);
      }
      else {
        icon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(48,48)), 'assets/location_pin.png');
      }

      Marker marker = Marker(
        markerId: markerId,
        position: MiscUtils.convertStringToLoc(await DatabaseUtils.getLocationFromEmail(f)),
        icon: icon,
        infoWindow: InfoWindow(title: f, snippet: statusText),
      );
      finalValue[markerId] = marker;
    }

    return finalValue;
  }
}
