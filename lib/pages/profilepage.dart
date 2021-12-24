import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String email;
  final String photoURL;

  const ProfilePage({Key? key, required this.email, required this.photoURL})
      : super(key: key);

    // make bottom app drawer with this link: https://stackoverflow.com/questions/54188895/how-to-implement-a-bottom-navigation-drawer-in-flutter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: NetworkImage(photoURL),
                          ))),
                ),
                Padding(
                  padding: EdgeInsets.all(0.04 * MediaQuery.of(context).size.height),
                  child: Text(email, style: TextStyle(
                    fontSize: 16,
                  ),),
                ),
                Text('Aaryan Patnaik', style: TextStyle(
                  fontSize: 24,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
