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

class EditHobbiesScreen extends StatefulWidget {
  String name = "";
  String surname = "";
  String email = "";
  String password = "";
  String picked = "";
  String country = "";
  String imageLocalPath = "";
  EditHobbiesScreen();
  static const String route = "signup_hobbies";
  @override
  _EditHobbiesScreenState createState() {
    return _EditHobbiesScreenState();
  }
}

class _EditHobbiesScreenState extends State<EditHobbiesScreen> {
  final Stream<QuerySnapshot> communities =
      FirebaseFirestore.instance.collection('Communities').snapshots();
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  String imageNetworkPath = "";
  var hobbiesList = [];
  //List<String> originalHobbies = [];
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

  retrieveOriginal() async {
    var document = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    document.get().then((document) {
      setState(() {
        // originalHobbies = document['hobbies'];
        hobbiesList = document['hobbies'];
        print(hobbiesList);
      });
    });
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

  initState() {
    retrieveOriginal();
  }

  registerUser() async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'hobbies': hobbiesList});
      print("Created");
    } catch (e) {
      print(e.toString());
    }
  }

  deleteUserfromUserList(hobby) async {
    var tmpuserlist = [];
    await FirebaseFirestore.instance
        .collection('Communities')
        .doc(hobby)
        .get()
        .then((doc) {
      tmpuserlist = doc['userlist'];
      tmpuserlist.removeWhere(
          (element) => element == FirebaseAuth.instance.currentUser!.uid);
      FirebaseFirestore.instance
          .collection('Communities')
          .doc(hobby)
          .update({"userlist": tmpuserlist});
    });
  }

  addUserfromUserList(hobby) async {
    var tmpuserlist = [];
    await FirebaseFirestore.instance
        .collection('Communities')
        .doc(hobby)
        .get()
        .then((doc) {
      tmpuserlist = doc['userlist'];
      tmpuserlist.add(FirebaseAuth.instance.currentUser!.uid);
      FirebaseFirestore.instance
          .collection('Communities')
          .doc(hobby)
          .update({"userlist": tmpuserlist});
    });
  }

  void _addHobby(String hobby) {
    setState(() {
      if (hobbiesList.contains(hobby) == false) {
        if (hobbiesList.length < 5) {
          hobbiesList.add(hobby);
          addUserfromUserList(hobby);
        }
      } else {
        hobbiesList.remove(hobby);
        deleteUserfromUserList(hobby);
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
                          child: TextField(
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
//           _EditHobbiesScreenState._addHobby();
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
