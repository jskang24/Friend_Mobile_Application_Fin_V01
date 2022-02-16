import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friend_mobile/app/app_theme.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:async';
import 'package:friend_mobile/ui/home/home_screen.dart';
import 'package:friend_mobile/ui/home/home_store.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:search_page/search_page.dart';

class HobbiesSelectScreen extends StatefulWidget {
  String name = "";
  String surname = "";
  String email = "";
  String password = "";
  String picked = "";
  String country = "";
  String imageLocalPath = "";
  HobbiesSelectScreen(
      {required this.name,
      required this.surname,
      required this.email,
      required this.password,
      required this.picked,
      required this.country,
      required this.imageLocalPath});
  static const String route = "signup_hobbies";
  @override
  _HobbiesSelectScreenState createState() {
    return _HobbiesSelectScreenState();
  }
}

class commHobby {
  String name;
  commHobby(this.name);
}

class _HobbiesSelectScreenState extends State<HobbiesSelectScreen> {
  final Stream<QuerySnapshot> communities =
      FirebaseFirestore.instance.collection('Communities').snapshots();
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  String imageNetworkPath = "";
  List<String> hobbiesList = [];
  var tmpUserList;
  updateUserList() async {
    for (var i in hobbiesList) {
      FirebaseFirestore.instance
          .collection('Communities')
          .doc()
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        setState(() {
          tmpUserList = documentSnapshot.data();
        });
      });
    }
  }

  calculateAge() {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - int.parse(widget.picked.substring(0, 4));
    int month1 = currentDate.month;
    int month2 = int.parse(widget.picked.substring(5, 7));
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = int.parse(widget.picked.substring(8, 10));
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  double longitude = 0;
  double latitude = 0;
  var data = [];
  List<commHobby> commList = [];

  _determinePosition() async {
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

    await Geolocator.getCurrentPosition().then((value) => setState(() {
          longitude = value.longitude;
          latitude = value.latitude;
          print(latitude);
          print(longitude);
        }));
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // return await Geolocator.getCurrentPosition();
  }

  retrieve() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Communities").get();
    data = querySnapshot.docs.map((doc) => doc.data()).toList();
    for (var i = 0; i < data.length; i++) {
      commList.add(commHobby(data[i]["name"]));
    }
  }

  registerUser() async {
    await _determinePosition();
    print(latitude);
    print(longitude);
    int age = calculateAge();
    try {
      final User? user =
          (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      ))
              .user;
      FirebaseFirestore.instance.collection('Users').doc(user!.uid).set({
        'Channels': [],
        'name': widget.name,
        'surname': widget.surname,
        'uid': user.uid,
        'email': user.email,
        'dob': widget.picked,
        'country': widget.country,
        'age': age,
        // 'isEmailVerified': user.emailVerified, // will also be false
        'photo': "", // will always be null
        'hobbies': hobbiesList,
        'aboutme': "",
        'longitude': longitude,
        'latitude': latitude,
        'likedposts': [],
        'posts': [],
        'pictures': [],
        'postsCommunity': [],
      });

      for (var a in hobbiesList) {
        DocumentReference addHobbies =
            FirebaseFirestore.instance.collection("Communities").doc(a);
        DocumentSnapshot add = await addHobbies.get();
        List users = add["userlist"];
        if (users.contains(user.uid) == false) {
          addHobbies.update({
            'userlist': FieldValue.arrayUnion([user.uid]),
          });
        }
      }
      print("Created");
    } catch (e) {
      print(e.toString());
    }
  }

  initState() {
    retrieve();
  }

  uploadProfile(String filePath) async {
    var date = DateTime.now();

    File file = File(filePath);

    String uname = FirebaseAuth.instance.currentUser!.uid;
    String time = date.year.toString() +
        "-" +
        date.month.toString() +
        "-" +
        date.day.toString() +
        "-" +
        date.hour.toString() +
        "_" +
        date.minute.toString() +
        "_" +
        date.second.toString();
    String imagename = "profile_" + uname + "_" + time;

    // print(time);
    await firebase_storage.FirebaseStorage.instance
        .ref('profilePic/${imagename}.jpg')
        .putFile(file);

    String downloadurl = await firebase_storage.FirebaseStorage.instance
        .ref('profilePic/${imagename}.jpg')
        .getDownloadURL();
    setState(() {
      imageNetworkPath = downloadurl;
      print("Local path: " + imageNetworkPath);
    });
  }

  updatePhotoLink() {
    print(imageNetworkPath);
    users
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'photo': imageNetworkPath})
        .then((value) => print("Photo Updated"))
        .catchError((error) => print("Failed to update Photo: $error"));
  }

  void _addHobby(String hobby) {
    setState(() {
      if (hobbiesList.contains(hobby) == false) {
        if (hobbiesList.length < 5) {
          hobbiesList.add(hobby);
        }
      } else {
        hobbiesList.remove(hobby);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: communities,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: Text("Loading")));
        }
        return Scaffold(
          body: Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    elevation: 0,
                    backgroundColor: Colors.white,
                    toolbarHeight: 72,
                    title: SvgPicture.asset(
                      "assets/images/communities_title.svg",
                    ),
                    bottom: PreferredSize(
                      child: Container(
                        color: Colors.white,
                        height: 80,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 36),
                          child: GestureDetector(
                            child: TextField(
                              onTap: () => showSearch(
                                context: context,
                                delegate: SearchPage<commHobby>(
                                  onQueryUpdate: (s) => print(s),
                                  items: commList,
                                  searchLabel: 'Search Communities',
                                  suggestion: Center(
                                    child: Text('Filter Communities'),
                                  ),
                                  failure: Center(
                                    child: Text('No Communities found...'),
                                  ),
                                  filter: (commHobby) => [
                                    commHobby.name,
                                  ],
                                  builder: (commHobby) => SizedBox(
                                      child: Text(
                                    commHobby.name,
                                  )),
                                ),
                              ),
                              decoration: InputDecoration(
                                prefixIcon: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Image.asset(
                                        "assets/images/search_icon.png"),
                                  ),
                                ),
                                hintText: "Search Hobbies",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      preferredSize: Size(
                        MediaQuery.of(context).size.width,
                        80,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          DocumentSnapshot data = snapshot.data!.docs[index];

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _addHobby(data['name']);
                              });
                            },
                            child: AnimatedContainer(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              height: 48,
                              width: hobbiesList.contains(data['name'])
                                  ? (data['name'].length.toDouble() * 10) + 70
                                  : (data['name'].length.toDouble() * 10) + 40,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOutCirc,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: hobbiesList.contains(data['name'])
                                    ? null
                                    : Border.all(color: Colors.grey),
                                color: hobbiesList.contains(data['name'])
                                    ? AppTheme.primaryColor
                                    : Colors.grey.shade50,
                              ),
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: hobbiesList.contains(data['name'])
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                child: SizedBox(
                                  height: 48,
                                  width: hobbiesList.contains(data['name'])
                                      ? (data['name'].length.toDouble() * 10) +
                                          72
                                      : (data['name'].length.toDouble() * 10) +
                                          40,
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          data['name'],
                                        ),
                                      ),
                                      hobbiesList.contains(data['name'])
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  left: (data['name']
                                                          .length
                                                          .toDouble() *
                                                      10)),
                                              child: const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                  elevation: 70,
                  color: Colors.white,
                  child: SizedBox(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "${hobbiesList.length}/5",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        CupertinoButton.filled(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          onPressed: () async {
                            await registerUser();
                            if (widget.imageLocalPath.substring(0, 5) ==
                                'asset') {
                              setState(() {
                                imageNetworkPath =
                                    "https://firebasestorage.googleapis.com/v0/b/friendapp-1be2f.appspot.com/o/profilePic%2Fdefault_profile.png?alt=media&token=2a4c2400-0d52-4445-b6a0-a9235a93e20b";
                              });
                            } else {
                              await uploadProfile(widget.imageLocalPath);
                            }
                            updatePhotoLink();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => HomeScreen(
                                    homeScreenStore: HomeScreenStore()),
                              ),
                              (route) => false,
                            );
                          },
                          child: Row(
                            children: const [
                              Text(
                                "Done",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.check,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

// class HobbyTile extends StatefulWidget {
//   const HobbyTile({
//     Key? key,
//     required this.color,
//     requiredata['name'],
//     // required this.onChanged,
//   }) : super(key: key);
//   final Color color;
//   final data['name'];
//   // final ValueChanged<String> onChanged;

//   @override
//   _HobbyTileState createState() => _HobbyTileState();
// }

// class _HobbyTileState extends State<HobbyTile> {
//   bool _isSelected = false;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _HobbiesSelectScreenState._addHobby();
//         });
//         // widget.onChanged.call(data['name']);
//       },
//       child: AnimatedContainer(
//         margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         height: 48,
//         width: _isSelected
//             ? (data['name'].length * 10) + 70
//             : (data['name'].length * 10) + 40,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOutCirc,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: _isSelected ? null : Border.all(color: Colors.grey),
//           color: _isSelected ? widget.color : Colors.grey.shade50,
//         ),
//         child: AnimatedDefaultTextStyle(
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.ease,
//           style: TextStyle(
//             fontSize: 16,
//             color: _isSelected ? Colors.white : Colors.black,
//           ),
//           child: SizedBox(
//             height: 48,
//             width: _isSelected
//                 ? (data['name'].length * 10) + 72
//                 : (data['name'].length * 10) + 40,
//             child: Stack(
//               children: [
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     data['name'],
//                   ),
//                 ),
//                 _isSelected
//                     ? Padding(
//                         padding:
//                             EdgeInsets.only(left: (data['name'].length * 10)),
//                         child: const Icon(
//                           Icons.check,
//                           color: Colors.white,
//                         ),
//                       )
//                     : Container(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
