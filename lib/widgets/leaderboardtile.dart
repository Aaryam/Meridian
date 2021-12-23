import 'package:flutter/material.dart';
import 'package:meridian/utils/colorutils.dart';

class LeaderboardTile extends StatelessWidget {
  final String email;
  final int position;
  final String distance;
  final String photoURL;

  const LeaderboardTile(
      {Key? key,
      required this.email,
      required this.position,
      required this.distance,
      required this.photoURL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String username = email.split("@")[0];

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.2,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.height * 0.05,
            right: MediaQuery.of(context).size.height * 0.05),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.height * 0.04),
              child: Text(
                '$position',
                style: TextStyle(
                  color: ColorUtils.deepBlue,
                  fontSize: 24,
                ),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.17,
                height: MediaQuery.of(context).size.width * 0.17,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: NetworkImage(photoURL),
                    ))),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height * 0.04),
              child: Text(
                '$username',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
