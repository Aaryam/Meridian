import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meridian/pages/leaderboardpage.dart';
import 'package:meridian/pages/loginpage.dart';
import 'package:meridian/pages/startpage.dart';
import 'package:meridian/utils/colorutils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meridian/utils/databaseutils.dart';
import 'package:meridian/utils/maputils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meridian/utils/miscutils.dart';
import 'package:meridian/utils/socialutils.dart';
import 'package:meridian/utils/widgetutils.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meridian',
      theme: ThemeData(
        primarySwatch: ColorUtils.skyBlue,
      ),
      home: StartPage(),
    );
  }
}

class ContentPage extends StatefulWidget {
  const ContentPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ContentPage> createState() => ContentPageState();
}

class ContentPageState extends State<ContentPage> {
  Completer<GoogleMapController> mapController = Completer();
  TextEditingController followBarController = TextEditingController();
  double openSize = 5;
  double pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.search, color: ColorUtils.deepBlue),
                  onPressed: () {
                    WidgetUtils.viewFollowSheet(context, followBarController);
                  }),
              IconButton(
                  icon: Icon(Icons.person, color: ColorUtils.deepBlue),
                  onPressed: () {
                    WidgetUtils.viewFriends(context, mapController, FirebaseAuth.instance.currentUser!.email);
                  }),
              SizedBox(width: 40), // The dummy child
              IconButton(
                  icon: Icon(Icons.leaderboard, color: ColorUtils.deepBlue),
                  onPressed: () {
                    WidgetUtils.viewLeaderboard(context, mapController);
                  }),
              IconButton(
                  icon: Icon(Icons.settings, color: ColorUtils.deepBlue),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    await GoogleSignIn().signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => LoginPage(
                          title: 'Meridian',
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          FutureBuilder<Map<MarkerId, Marker>>(
            future: MapUtils.getMarkers(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GoogleMap(
                  markers: Set<Marker>.of(
                      (snapshot.data as Map<MarkerId, Marker>).values),
                  mapType: MapType.terrain,
                  initialCameraPosition:
                      const CameraPosition(target: LatLng(0, 0)),
                  onMapCreated: (GoogleMapController controller) {
                    mapController.complete(controller);
                  },
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: GestureDetector(
        child: FloatingActionButton(
          elevation: 0,
          onPressed: () async {
            String email = FirebaseAuth.instance.currentUser!.email as String;
            LatLng oldPos = MiscUtils.convertStringToLoc(
                await DatabaseUtils.getLocationFromEmail(email));
            LatLng newPos = await MapUtils.getLoc();
            await MapUtils.animateLoc(mapController, await MapUtils.getLoc());
            await DatabaseUtils.setLocation(email, await MapUtils.getLoc());
            await SocialUtils.updateDistance(email, oldPos, newPos);
            //await DatabaseUtils.setIsParty(email, false);
            await SocialUtils.addLeaderboard(email);
          },
          backgroundColor: ColorUtils.deepBlue,
          child: const Icon(Icons.location_pin, color: Colors.white),
        ),
      ),
    );
  }
}

/*

*/
