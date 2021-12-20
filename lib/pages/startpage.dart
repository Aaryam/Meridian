import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meridian/main.dart';

import 'loginpage.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (FirebaseAuth.instance.currentUser != null) {

            // user is logged in: show the main page

            return ContentPage(title: 'Content');
          }
          else {

            // user is not logged in: show the login page
            
            return LoginPage(title: 'Login');
          }
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return Center(
            child: Container(
              height: 100,
              width: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}
