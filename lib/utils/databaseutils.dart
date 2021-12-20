import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'miscutils.dart';

class DatabaseUtils {
  static Future<bool> addUser(String email, String photoURL) async {

    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(email);

    if (!((await docRef.get()).exists)) {
      LocationData loc = await Location().getLocation();
      docRef.set({
        'location': loc.latitude.toString() + "|" + loc.longitude.toString(),
        'status': 'Hi!',
        'photoURL': photoURL,
      });
      await followUser(email, email);
      return true;
    } else {
      return false;
    }
  }

  static Future<List<double>> getLatLong(email) async {
    DocumentSnapshot<Map<String, dynamic>> docRef =
        await FirebaseFirestore.instance.collection('users').doc(email).get();

    List<double> finalList = [];

    finalList.add(((docRef.data()!['location'] as String).split("|")[0]) as double);
    finalList.add(((docRef.data()!['location'] as String).split("|")[1]) as double);

    return finalList;
  }

  static Future<bool> setLocation(String email, LatLng loc) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(email);

    docRef.update({
      'location': MiscUtils.convertLocToString(loc),
    }).catchError(
      () {
        return false;
      }
    );

    return true;
  }

  static Future<String> getLocationFromEmail(String email) async {
    DocumentSnapshot<Map<String, dynamic>> docRef = await FirebaseFirestore.instance.collection('users').doc(email).get();
    
    return docRef.data()!['location'];
  }

  static Future<String> getPhotoURLFromEmail(String email) async {
    DocumentSnapshot<Map<String, dynamic>> docRef = await FirebaseFirestore.instance.collection('users').doc(email).get();
    
    return docRef.data()!['photoURL'];
  }

  static Future<List<String>> getFollowingList(String email) async {
    var docRef = FirebaseFirestore.instance.collection('users').doc(email).collection('following');
    var values = await docRef.get();
    List<String> followingList = [];

    values.docs.forEach((element) { 
      followingList.add(element['email']);
    });

    return followingList;
  }

  static Future<bool> followUser(String followerEmail, String followeeEmail) async {

    bool finalValue = true;

    if (!(await userExists(followeeEmail)) || !(await userExists(followerEmail))) {
      return false;
    }

    await FirebaseFirestore.instance.collection('users').doc(followerEmail).collection('following').add({
      'email': followeeEmail,
    });

    await FirebaseFirestore.instance.collection('users').doc(followeeEmail).collection('followers').add({
      'email': followerEmail,
    });

    return finalValue;
  }

  static Future<bool> userExists (String email) async {
    return (await FirebaseFirestore.instance.collection('users').doc(email).get()).exists;
  }
}
