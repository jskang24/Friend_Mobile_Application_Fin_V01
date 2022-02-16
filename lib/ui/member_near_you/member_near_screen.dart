import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friend_mobile/app/app_theme.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:friend_mobile/ui/messages/actual_chat.dart';

class MembersNearScreen extends StatefulWidget {
  String name = "";
  // const MembersNearScreen({Key? key}) : super(key: key);
  static const String route = 'MembersNearYou';
  MembersNearScreen({required this.name});
  @override
  _MembersNearScreenState createState() => _MembersNearScreenState();
}

double rangeValue = 45;

class _MembersNearScreenState extends State<MembersNearScreen> {
  double updateLatitude = 0;
  double updateLongitude = 0;

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // return await Geolocator.getCurrentPosition();
    await Geolocator.getCurrentPosition().then((value) => setState(() {
          updateLongitude = value.longitude;
          updateLatitude = value.latitude;
          FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update(
                  {'longitude': updateLongitude, 'latitude': updateLatitude});
          retrieve();
        }));
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  List userList = [];
  List userInfo = [];
  retrieve() async {
    var document = await FirebaseFirestore.instance
        .collection('Communities')
        .doc(widget.name);

    document.get().then((document) {
      setState(() {
        userList = document['userlist'];
        userList = userList.sublist(
          1,
        );
        for (var uid in userList) {
          // print("WTF");
          var docs = FirebaseFirestore.instance.collection('Users').doc(uid);
          docs.get().then((docs) {
            setState(() {
              String name = docs['name'];
              String surName = docs['surname'];
              String country = docs['country'];
              String photo = docs['photo'];
              String age = docs['age'].toString();
              double longitude = docs['longitude'];
              double latitude = docs['latitude'];
              String uid = docs['uid'];
              double dist = calculateDistance(
                  latitude, longitude, updateLatitude, updateLongitude);
              List user = [name, surName, country, photo, age, dist, uid];
              if (user[6] != FirebaseAuth.instance.currentUser!.uid) {
                userInfo.add(user);
              }
              // print(user);
            });
          });
        }
      });
    });
    // print(userList);

    // print(userInfo);
  }

  void initState() {
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    if (userInfo.isEmpty == true) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.secondaryColor,
          foregroundColor: Colors.white,
          leadingWidth: 28,
          centerTitle: false,
          elevation: 0,
          // actions: [
          //   IconButton(
          //     splashColor: Colors.white38,
          //     splashRadius: 20,
          //     icon: const Icon(Icons.search),
          //     onPressed: () {},
          //   ),
          // ],
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.name),
              Text(
                "Members Near You",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: 0,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.white,
              bottom: PreferredSize(
                child: SizedBox(
                  height: 150,
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Range",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              rangeValue.toInt().toString() + " Kilometers",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Slider(
                        thumbColor: AppTheme.secondaryColor,
                        inactiveColor: Colors.grey.shade300,
                        max: 80,
                        min: 1,
                        onChanged: (cVal) {
                          setState(() {
                            rangeValue = cVal;
                          });
                        },
                        value: rangeValue,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: 36, vertical: 6),
                      //   // child: TextField(
                      //   //   decoration: InputDecoration(
                      //   //     prefixIcon: SizedBox(
                      //   //       width: 16,
                      //   //       height: 16,
                      //   //       child: Padding(
                      //   //         padding: const EdgeInsets.all(14.0),
                      //   //         child: Image.asset(
                      //   //             "assets/images/search_icon.png"),
                      //   //       ),
                      //   //     ),
                      //   //     hintText: "Search",
                      //   //     border: OutlineInputBorder(
                      //   //       borderRadius: BorderRadius.circular(10),
                      //   //     ),
                      //   //   ),
                      //   // ),
                      // ),
                    ],
                  ),
                ),
                preferredSize: Size(MediaQuery.of(context).size.width, 150),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (rangeValue >= userInfo[index][5]) {
                    return NearMemberListTile(
                      name: userInfo[index][0] + " " + userInfo[index][1],
                      age: userInfo[index][4],
                      imgUrl: userInfo[index][3],
                      country: userInfo[index][2],
                      index: index,
                      range: userInfo[index][5].toString(),
                      uid2: userInfo[index][6],
                    );
                  }
                },
                childCount: userInfo.length,
              ),
            ),
          ],
        ),
      );
    }
  }
}

class NearMemberListTile extends StatefulWidget {
  String name = "", age = "", country = "", range = "", imgUrl = "", uid2 = "";
  int index = 0;
  NearMemberListTile({
    required this.name,
    required this.age,
    required this.country,
    required this.range,
    required this.imgUrl,
    required this.index,
    required this.uid2,
  });
  @override
  _NearMemberListTile createState() => _NearMemberListTile();
}

class _NearMemberListTile extends State<NearMemberListTile> {
  String uid1 = "";

  updateUser2Chat() async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.uid2)
        .get()
        .then((doc) {
      var tmpChannels = [];
      tmpChannels = doc["Channels"];
      tmpChannels.add(uid1 + "-" + widget.uid2);

      FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.uid2)
          .update({"Channels": tmpChannels});
    });
  }

  createChatChannel() async {
    print(uid1);
    print(widget.uid2);
    setState(() {
      uid1 = FirebaseAuth.instance.currentUser!.uid;
    });

    FirebaseFirestore.instance.collection('Users').doc(uid1).get().then((doc) {
      var tmpChannels = [];
      if (doc["Channels"].contains(uid1 + "-" + widget.uid2) == false &&
          doc["Channels"].contains(widget.uid2 + "-" + uid1) == false) {
        tmpChannels = doc["Channels"];
        tmpChannels.add(uid1 + "-" + widget.uid2);
        updateUser2Chat();
        FirebaseFirestore.instance
            .collection('Users')
            .doc(uid1)
            .update({"Channels": tmpChannels});
      } else if (doc["Channels"].contains(uid1 + "-" + widget.uid2)) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ActualChat(channelName: uid1 + "-" + widget.uid2)),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ActualChat(channelName: widget.uid2 + "-" + uid1)),
        );
      }
    });
    //uid, widget.uid2
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget.index.isEven ? Colors.white : Colors.grey.shade100,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.imgUrl),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        height: 13,
                        width: 18,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.green),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "${widget.age} years old",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  Text(
                    "${widget.range} miles",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  createChatChannel();
                },
                child: SvgPicture.asset("assets/icons/message_2.svg"),
              ),
              SizedBox(width: 24),
              InkWell(
                onTap: () {},
                child: SvgPicture.asset("assets/icons/call_3.svg"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
