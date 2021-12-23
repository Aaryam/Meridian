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
        'distance': '0.0',
        'isParty': false,
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

    finalList
        .add(((docRef.data()!['location'] as String).split("|")[0]) as double);
    finalList
        .add(((docRef.data()!['location'] as String).split("|")[1]) as double);

    return finalList;
  }

  static Future<bool> setLocation(String email, LatLng loc) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(email);

    docRef.update({
      'location': MiscUtils.convertLocToString(loc),
    });

    return true;
  }

  static Future<String> getLocationFromEmail(String email) async {
    DocumentSnapshot<Map<String, dynamic>> docRef =
        await FirebaseFirestore.instance.collection('users').doc(email).get();

    return docRef.data()!['location'];
  }

  static Future<String> getPhotoURLFromEmail(String email) async {
    DocumentSnapshot<Map<String, dynamic>> docRef =
        await FirebaseFirestore.instance.collection('users').doc(email).get();

    return docRef.data()!['photoURL'];
  }

  static Future<List<String>> getFollowingList(String email) async {
    var docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('following');
    var values = await docRef.get();
    List<String> followingList = [];

    values.docs.forEach((element) {
      followingList.add(element['email']);
    });

    return followingList;
  }

  static Future<bool> followUser(
      String followerEmail, String followeeEmail) async {
    bool finalValue = true;

    if (!(await userExists(followeeEmail)) ||
        !(await userExists(followerEmail))) {
      return false;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(followerEmail)
        .collection('following')
        .doc(followeeEmail)
        .set({
      'email': followeeEmail,
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(followeeEmail)
        .collection('followers')
        .doc(followerEmail)
        .set({
      'email': followerEmail,
    });

    return finalValue;
  }

  static Future<bool> unfollowUser(
      String followerEmail, String followeeEmail) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(followeeEmail)
        .collection('followers')
        .doc(followerEmail)
        .delete();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(followerEmail)
        .collection('following')
        .doc(followeeEmail)
        .delete();

    return true;
  }

  static Future<bool> userExists(String email) async {
    return (await FirebaseFirestore.instance
            .collection('users')
            .doc(email)
            .get())
        .exists;
  }

  static Future<bool> setStatus(String email, String status) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(email);

    await docRef.update({
      'status': status,
    });

    return true;
  }

  static Future<bool> setDistance(String email, double newDistance) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(email);

    await docRef.update({
      'distance': newDistance.toString(),
    });

    return true;
  }

  static Future<String> getStatus(String email) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(email);

    var val = await docRef.get();

    String status = val['status'];

    return status;
  }

  static Future<double> getDistance(String email) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(email);

    var val = await docRef.get();

    String distance = val['distance'];
    
    return double.parse(distance);
  }

  static Future<bool> isParty(String email) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(email);

    var val = await docRef.get();

    bool isParty = val['isParty'];

    return isParty;
  }

  static Future<bool> setIsParty(String email, bool isParty) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(email);

    await docRef.update({
      'isParty': isParty,
    });

    return true;
  }
}
