import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meridian/utils/databaseutils.dart';
import 'package:meridian/utils/maputils.dart';
import 'package:meridian/utils/miscutils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GeoCircle extends StatelessWidget {
  final String photoURL;
  final String email;
  final Completer<GoogleMapController> mapController;

  const GeoCircle({Key? key, required this.photoURL, required this.email, required this.mapController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: GestureDetector(
        onLongPress: () async {
          DatabaseUtils.unfollowUser(FirebaseAuth.instance.currentUser!.email as String, email);
        },
        onTap: () async {
          LatLng loc = MiscUtils.convertStringToLoc(await DatabaseUtils.getLocationFromEmail(email));

          MapUtils.animateLoc(mapController, loc);
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.2,
          height: MediaQuery.of(context).size.width * 0.2,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.contain,
                image: NetworkImage(photoURL),
              ))),
      ),
    );
  }
}
