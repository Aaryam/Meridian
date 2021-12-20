import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meridian/main.dart';
import 'package:meridian/utils/colorutils.dart';
import 'package:meridian/utils/databaseutils.dart';
import 'package:meridian/utils/socialutils.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: Container(
              color: ColorUtils.deepBlue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Text(
                        'Teleport across the world with Meridian.',
                        style: TextStyle(
                          color: ColorUtils.skyBlue,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  FlatButton(
                    minWidth: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: const Icon(Icons.login_outlined),
                    color: ColorUtils.skyBlue,
                    textColor: ColorUtils.deepBlue,
                    onPressed: () async {
                      if (FirebaseAuth.instance.currentUser != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ContentPage(
                                title: 'Meridian',
                              ),
                            ));
                      } else {
                        User? me = await SocialUtils.signInWithGoogle(context: context);
                        await DatabaseUtils.addUser(me!.email as String, me.photoURL as String);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => ContentPage(
                              title: 'Meridian',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return CircularProgressIndicator(
            color: ColorUtils.skyBlue,
          );
        }
      },
    );
  }
}
