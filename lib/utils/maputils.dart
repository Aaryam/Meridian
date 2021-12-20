import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapUtils {
  static Future<LatLng> getLoc() async {
    LocationData loc = await Location().getLocation();

    return LatLng(loc.latitude as double, loc.longitude as double);
  }

  static CameraPosition locToCameraPos(loc, zoom) {
    return CameraPosition(target: loc, zoom: zoom);
  }

  static Future<void> animateLoc(Completer<GoogleMapController> mapController, LatLng loc) async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(locToCameraPos(loc, 20.0)));
  }
}
