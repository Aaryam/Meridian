import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meridian/utils/databaseutils.dart';
import 'package:meridian/utils/miscutils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SocialUtils {
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            print(e);
          } else if (e.code == 'invalid-credential') {
            print(e);
          }
        } catch (e) {
          print(e);
        }
      }
    }

    return user;
  }

  static Future<bool> updateDistance(
      String email, LatLng oldPos, LatLng newPos) async {
    double currentDistance = await DatabaseUtils.getDistance(email);
    double distanceCovered = MiscUtils.findDistance(newPos, oldPos);

    await DatabaseUtils.setDistance(email, currentDistance + distanceCovered);

    return true;
  }

  static Future<List<Map<String, dynamic>>> getLeaderboards() async {
    var docRef = FirebaseFirestore.instance.collection('leaderboard');
    var x = await docRef.orderBy('distance', descending: true).limit(20).get();
    List<Map<String, dynamic>> leaderboardList = [];

    for (int i = 0; i < x.size; i++) {
      leaderboardList.add({
        'email': x.docs[i]['email'],
        'distance': x.docs[i]['distance'],
      });
    }

    return leaderboardList;
  }

  static Future<bool> addLeaderboard(String email) async {
    var docRef = FirebaseFirestore.instance.collection('leaderboard');
    double distance = await DatabaseUtils.getDistance(email);

    docRef.doc(email).set({
      'email': email,
      'distance': distance,
    });

    return true;
  }
}
