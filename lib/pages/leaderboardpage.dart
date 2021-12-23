import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meridian/main.dart';
import 'package:meridian/utils/colorutils.dart';
import 'package:meridian/utils/databaseutils.dart';
import 'package:meridian/utils/miscutils.dart';
import 'package:meridian/utils/socialutils.dart';
import 'package:meridian/widgets/leaderboardtile.dart';

class LeaderboardPage extends StatefulWidget {
  LeaderboardPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  LeaderboardPageState createState() => LeaderboardPageState();
}

class LeaderboardPageState extends State<LeaderboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorUtils.deepBlue,
        foregroundColor: Colors.white,
        title: Text('Meridian'),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ContentPage(
                  title: 'Meridian',
                ),
              ),
            );
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {

          // refresh page by rebuilding state with setState

          setState(() {});
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
                String photoURL =
                    'https://lh3.googleusercontent.com/a-/AOh14GiGiSXNkjWaPWgmuXq9l6bp2d8MQ5w6OMZHkvdA=s96-c';
                return LeaderboardTile(
                  email: (snapshot.data![i]['email'] as String),
                  distance: distance,
                  position: i,
                  photoURL: photoURL,
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
      ),
    );
  }
}
