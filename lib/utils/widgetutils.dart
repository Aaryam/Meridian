import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meridian/pages/profilepage.dart';
import 'package:meridian/utils/databaseutils.dart';
import 'package:meridian/utils/miscutils.dart';
import 'package:meridian/utils/socialutils.dart';
import 'package:meridian/widgets/geocircle.dart';
import 'package:meridian/widgets/leaderboardtile.dart';

import 'colorutils.dart';

class WidgetUtils {
  static Widget locationSpheres(mapController) {
    return FutureBuilder<List<String>>(
      future: DatabaseUtils.getFollowingList(
          FirebaseAuth.instance.currentUser!.email as String),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            shrinkWrap: false,
            itemBuilder: (context, n) {
              var userEmail = snapshot.data![n];
              return FutureBuilder(
                future: DatabaseUtils.getPhotoURLFromEmail(userEmail),
                builder: (c, photoSnapshot) {
                  if (photoSnapshot.hasData &&
                      photoSnapshot.connectionState == ConnectionState.done) {
                    var photoURL = photoSnapshot.data as String;
                    return GeoCircle(
                      photoURL: photoURL,
                      email: userEmail,
                      mapController: mapController,
                    );
                  } else if (photoSnapshot.hasError) {
                    return Text(photoSnapshot.error.toString());
                  } else {
                    return Container();
                  }
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return Center(
            child: SizedBox(
              height: 80,
              width: 80,
              child: CircularProgressIndicator(
                color: ColorUtils.deepBlue,
              ),
            ),
          );
        }
      },
    );
  }

  static Widget followBar(
      TextEditingController controller, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Container(
            width: (MediaQuery.of(context).size.width * 0.7) - 10,
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter a user's email to follow."),
            ),
          ),
          FlatButton(
            minWidth: (MediaQuery.of(context).size.width * 0.2) - 10,
            onPressed: () async {
              await DatabaseUtils.followUser(
                  FirebaseAuth.instance.currentUser!.email as String,
                  controller.value.text);
            },
            child: Icon(Icons.person_add),
          ),
        ],
      ),
    );
  }

  static void viewFriendsSheet(context, mapController) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          'Following',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 50, bottom: 50),
                      child: Container(
                        child: WidgetUtils.locationSpheres(mapController),
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static void viewFollowSheet(context, followBarController) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          'Follow',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 50, bottom: 50),
                      child: Container(
                        child:
                            WidgetUtils.followBar(followBarController, context),
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static void viewLeaderboard(context, mapController) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return RefreshIndicator(
            onRefresh: () async {
              // refresh page by rebuilding state with setState

            },
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: SocialUtils.getLeaderboards(),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    itemBuilder: (context, i) {
                      String distance = (MiscUtils.convertLatToKM(
                                  double.parse(snapshot.data![i]['distance']))
                              .round())
                          .toString();
                      String photoURL = '';
                      return FutureBuilder<String>(
                        future: DatabaseUtils.getPhotoURLFromEmail(
                            snapshot.data![i]['email'] as String),
                        builder: (c, photoSnap) {
                          if (photoSnap.hasData &&
                              photoSnap.connectionState ==
                                  ConnectionState.done) {
                            photoURL = photoSnap.data as String;
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => ProfilePage(
                                      email: (snapshot.data![i]['email']
                                          as String),
                                      photoURL: photoURL,
                                    ),
                                  ),
                                );
                              },
                              child: LeaderboardTile(
                                email: (snapshot.data![i]['email'] as String),
                                distance: distance,
                                position: i + 1,
                                photoURL: photoURL,
                                mapController: mapController,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          } else {
                            return Center(
                              child: Container(),
                            );
                          }
                        },
                      );
                    },
                    itemCount: snapshot.data!.length,
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString(),
                      style: TextStyle(
                        fontSize: 10,
                      ));
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
          );
        });
  }

  static void viewFriends(context, mapController, email) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return RefreshIndicator(
            onRefresh: () async {
              // refresh page by rebuilding state with setState
            },
            child: FutureBuilder<List<String>>(
              future: DatabaseUtils.getFollowingList(email),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    itemBuilder: (context, i) {
                      String photoURL = '';
                      return FutureBuilder<String>(
                        future: DatabaseUtils.getPhotoURLFromEmail(snapshot.data![i]),
                        builder: (c, photoSnap) {
                          if (photoSnap.hasData &&
                              photoSnap.connectionState ==
                                  ConnectionState.done) {
                            photoURL = photoSnap.data as String;
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => ProfilePage(
                                      email: snapshot.data![i],
                                      photoURL: photoURL,
                                    ),
                                  ),
                                );
                              },
                              child: LeaderboardTile(
                                email: (snapshot.data![i]),
                                distance: '',
                                position: i + 1,
                                photoURL: photoURL,
                                mapController: mapController,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          } else {
                            return Center(
                              child: Container(),
                            );
                          }
                        },
                      );
                    },
                    itemCount: snapshot.data!.length,
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString(),
                      style: TextStyle(
                        fontSize: 10,
                      ));
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
          );
        });
  }
}
